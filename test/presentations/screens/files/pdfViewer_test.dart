import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../auxfiles/pdfViewer_aux.dart';

void main() {
  testWidgets('PdfViewerScreen shows app bar with title and PDF viewer placeholder', (tester) async {
    const testUrl = 'https://example.com/sample.pdf';
    const testTitle = 'Test PDF';

    await tester.pumpWidget(
      MaterialApp(
        home: PdfViewerScreen(
          url: testUrl,
          title: testTitle,
          pdfViewerBuilder: (url) => const Center(child: Text('Mock PDF Viewer')),
        ),
      ),
    );

    expect(find.text(testTitle), findsOneWidget);
    expect(find.text('Mock PDF Viewer'), findsOneWidget);
  });
}
