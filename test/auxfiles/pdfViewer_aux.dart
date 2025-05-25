import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

typedef PdfViewerBuilder = Widget Function(String url);

class PdfViewerScreen extends StatelessWidget {
  final String url;
  final String title;
  final PdfViewerBuilder? pdfViewerBuilder;

  const PdfViewerScreen({
    super.key,
    required this.url,
    required this.title,
    this.pdfViewerBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final pdfViewer = pdfViewerBuilder?.call(url) ?? SfPdfViewer.network(url);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: pdfViewer,
    );
  }
}
