import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nutrabit_paciente/presentations/providers/interest_item_provider.dart';
import 'package:nutrabit_paciente/widgets/drawer.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class InterestList extends ConsumerStatefulWidget {
  const InterestList({super.key});

  @override
  ConsumerState<InterestList> createState() => _InterestListState();
}

class _InterestListState extends ConsumerState<InterestList> {
  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(interestItemsProvider);
    final notifier = ref.read(interestItemsProvider.notifier);

    return Scaffold(
      endDrawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        scrolledUnderElevation: 0, 
        centerTitle: true,
        actions: [
          Builder(
            builder:
                (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFFF0F6),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No hay ítems aún.'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final url = item.url.toLowerCase();

                    if ((url.contains('youtube')) || (url.contains('youtu.be'))) {
                      return YoutubeEmbedCard(
                        itemId: item.id,
                        itemTitle: item.title,
                        youtubeUrl: item.url,
                      );
                    } else if (url.contains('spotify')) {
                      return SpotifyEmbedCard(
                        itemId: item.id,
                        itemTitle: item.title,
                        spotifyUrl: item.url,
                      );
                    } else {
                      return GenericLinkCard(
                        itemId: item.id,
                        itemTitle: item.title,
                        linkUrl: item.url,
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: notifier.hasPreviousPage ? notifier.previousPage : null,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.pink,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Colors.pink),
                        ),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 16),
                    ),
                    const SizedBox(width: 24),
                    Text(
                      'Página ${ref.watch(interestItemsProvider.notifier).currentPage + 1}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(width: 24),
                    ElevatedButton(
                      onPressed: notifier.hasNextPage ? notifier.nextPage : null,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.pink,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Colors.pink),
                        ),
                      ),
                      child: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


class YoutubeEmbedCard extends StatefulWidget {
  final String itemId;
  final String itemTitle;
  final String youtubeUrl;

  const YoutubeEmbedCard({
    super.key,
    required this.itemId,
    required this.itemTitle,
    required this.youtubeUrl,
  });

  @override
  State<YoutubeEmbedCard> createState() => _YoutubeEmbedCardState();
}

class _YoutubeEmbedCardState extends State<YoutubeEmbedCard>
    with AutomaticKeepAliveClientMixin {
  YoutubePlayerController? _controller;
  bool _isPlaying = false;

  @override
  bool get wantKeepAlive => true;

  String? extractYoutubeVideoId(String url) {
    final regExp = RegExp(r'(?:v=|\/)([0-9A-Za-z_-]{11})');
    final match = regExp.firstMatch(url);
    return match?.group(1);
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  void _startPlaying() {
    final videoId = extractYoutubeVideoId(widget.youtubeUrl);
    if (videoId == null) return;

    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );

    _controller!.loadVideoById(videoId: videoId);
    setState(() => _isPlaying = true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final videoId = extractYoutubeVideoId(widget.youtubeUrl);
    final thumbnailUrl =
        videoId != null
            ? 'https://img.youtube.com/vi/$videoId/hqdefault.jpg'
            : null;

    return RecommendationCard(
      title: widget.itemTitle,
      source: "YouTube",
      child:
          _isPlaying && _controller != null
              ? YoutubePlayer(controller: _controller!, aspectRatio: 16 / 9)
              : GestureDetector(
                onTap: _startPlaying,
                child:
                    thumbnailUrl != null
                        ? Stack(
                          alignment: Alignment.center,
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: CachedNetworkImage(
                                imageUrl: thumbnailUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const Icon(
                              Icons.play_circle_fill_rounded,
                              color: Colors.white,
                              size: 64,
                            ),
                          ],
                        )
                        : const Center(child: Text("Video no válido")),
              ),
    );
  }
}

class SpotifyEmbedCard extends StatefulWidget {
  final String itemId;
  final String itemTitle;
  final String spotifyUrl;

  const SpotifyEmbedCard({
    super.key,
    required this.itemId,
    required this.itemTitle,
    required this.spotifyUrl,
  });

  @override
  State<SpotifyEmbedCard> createState() => _SpotifyEmbedCardState();
}

class _SpotifyEmbedCardState extends State<SpotifyEmbedCard>
    with AutomaticKeepAliveClientMixin {
  late final WebViewController _controller;

  @override
  bool get wantKeepAlive => true;

  String _generateSpotifyHtml(String embedUrl) {
    return '''
      <!DOCTYPE html>
      <html>
      <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
      <body style="margin:0;padding:0;">
        <iframe src="$embedUrl"
          width="100%" height="352" frameborder="0"
          allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture"
          loading="lazy">
        </iframe>
      </body>
      </html>
    ''';
  }

  void openSpotifyIntent(String id, String type) async {
    try {
      final intent = AndroidIntent(
        action: 'action_view',
        data: 'spotify://$type/$id',
        package: 'com.spotify.music',
      );
      await intent.launch();
    } catch (e) {
      final fallback = 'https://open.spotify.com/$type/$id';
      if (await canLaunchUrl(Uri.parse(fallback))) {
        await launchUrl(
          Uri.parse(fallback),
          mode: LaunchMode.externalApplication,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final uri = Uri.tryParse(widget.spotifyUrl);
    final segments = uri?.pathSegments;
    if (segments == null || segments.length < 2) return;
    final type = segments[0];
    final id = segments[1].split('?').first;
    final embedUrl = 'https://open.spotify.com/embed/$type/$id';

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (request) {
                if (request.url.contains("spotify.com")) {
                  openSpotifyIntent(id, type);
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadHtmlString(_generateSpotifyHtml(embedUrl));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RecommendationCard(
      title: widget.itemTitle,
      source: "Spotify",
      child: SizedBox(
        height: 352,
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}

class RecommendationCard extends StatelessWidget {
  final String title;
  final String? source;
  final Widget child;

  const RecommendationCard({
    super.key,
    required this.title,
    this.source,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            title: Text(title, style: Theme.of(context).textTheme.titleMedium),
            subtitle:
                (source != null && source!.isNotEmpty)
                    ? Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "Fuente: $source",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    )
                    : null
          ),
          const Divider(height: 1),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

class GenericLinkCard extends StatelessWidget {
  final String itemId;
  final String itemTitle;
  final String linkUrl;

  const GenericLinkCard({
    super.key,
    required this.itemId,
    required this.itemTitle,
    required this.linkUrl,
  });

  String getDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host.replaceFirst('www.', '');
    } catch (_) {
      return '';
    }
  }

  String getFaviconUrl(String url) {
  try {
    final uri = Uri.parse(url);
    final domain = uri.host;

    // Para test en emulador con localhost descomentar todo el if para que use la cloud function que es un proxy que obtiene los favicon
    // volver a comentar si no se usa para evitar llamadas innecesarias a la db 

    
    // if (kIsWeb && (Uri.base.host == 'localhost' || Uri.base.host == '127.0.0.1')) {
    //  const projectId = 'nutrabit-7a4ce';
    //  const region = 'us-central1';
    //  return 'https://$region-$projectId.cloudfunctions.net/faviconProxy?domain=$domain';
    // }

    return 'https://www.google.com/s2/favicons?domain=$domain&sz=64';
  } catch (_) {
    return '';
  }
  }

  void _openLink() async {
    final uri = Uri.tryParse(linkUrl);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final domain = getDomain(linkUrl);
    final favicon = getFaviconUrl(linkUrl);

    return RecommendationCard(
      title: itemTitle,
      source: null,
      child: InkWell(
        onTap: _openLink,
        child: Container(
          color: Colors.grey.shade50,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 40,
                  height: 40,
                  color: Colors.white,
                  child: Image.network(
                    favicon,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => const Icon(
                          Icons.cloud,
                          size: 40,
                          color: Color.fromARGB(255, 143, 180, 248),
                        ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  domain,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4, right: 8),
                child: const Icon(
                  Icons.open_in_new_rounded,
                  color: Color.fromARGB(255, 143, 180, 248),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
