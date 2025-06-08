import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrabit_paciente/core/models/interest_item_model.dart';

final interestItemsProvider =
    AsyncNotifierProvider<InterestItemsNotifier, List<InterestItem>>(
  InterestItemsNotifier.new,
);

class InterestItemsNotifier extends AsyncNotifier<List<InterestItem>> {
  static const int _limit = 10;
  late final CollectionReference<Map<String, dynamic>> _collection;

  int _currentPage = 0;
  final List<DocumentSnapshot<Map<String, dynamic>>> _cursors = [];
  bool _hasNextPage = true;
  bool _isFetching = false;

  @override
  Future<List<InterestItem>> build() async {
    _collection = FirebaseFirestore.instance.collection('interestItems');
    return _loadPage(0);
  }

  Future<List<InterestItem>> _loadPage(int pageIndex) async {
    if (_isFetching) {
      return state.value ?? [];
    }
    _isFetching = true;
    state = const AsyncLoading();

    try {
      // Pedimos _limit + 1 para detectar si hay una página siguiente real
      Query<Map<String, dynamic>> query = _collection
          .orderBy('createdAt', descending: true)
          .limit(_limit + 1);

      if (pageIndex > 0 && pageIndex - 1 < _cursors.length) {
        query = query.startAfterDocument(_cursors[pageIndex - 1]);
      }

      final snapshot = await query.get();
      final allDocs = snapshot.docs;

      // Si recibimos más de _limit, sabemos que hay siguiente página
      final bool existeSiguiente = allDocs.length > _limit;
      _hasNextPage = existeSiguiente;

      // Si hay siguiente, cortamos a los primeros _limit; si no, usamos todos
      final docs = existeSiguiente
          ? allDocs.sublist(0, _limit)
          : allDocs;

      if (docs.isNotEmpty) {
        if (_cursors.length <= pageIndex) {
          _cursors.add(docs.last);
        } else {
          _cursors[pageIndex] = docs.last;
        }
      }

      _currentPage = pageIndex;
      final items = docs.map((d) => InterestItem.fromMap(d.data(), d.id)).toList();
      state = AsyncData(items);
      return items;
    } catch (e, st) {
      state = AsyncError(e, st);
      return [];
    } finally {
      _isFetching = false;
    }
  }

  Future<void> nextPage() async {
    if (!_hasNextPage) return;
    await _loadPage(_currentPage + 1);
  }

  Future<void> previousPage() async {
    if (_currentPage <= 0) return;
    await _loadPage(_currentPage - 1);
  }

  int get currentPage => _currentPage;
  bool get hasNextPage => _hasNextPage;
  bool get hasPreviousPage => _currentPage > 0;
}