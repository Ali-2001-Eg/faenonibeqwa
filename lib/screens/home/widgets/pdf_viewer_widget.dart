import 'dart:io';

import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerWidget extends StatelessWidget {
  // Path to the local PDF file
  final String pdfPath;
  final bool networkSource;

  const PdfViewerWidget({super.key, required this.pdfPath, required this.networkSource});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: 'المحاضره'),
        body: networkSource
            ? SfPdfViewer.network(
                pdfPath,
              )
            : SfPdfViewer.file(
                File(pdfPath),
              ));
  }
}
