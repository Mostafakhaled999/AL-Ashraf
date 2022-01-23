import 'package:flutter/material.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:al_ashraf/models/book.dart';

class PdfViewerScreen extends StatefulWidget {
  Book book;

  PdfViewerScreen({required this.book});

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: CustomWidgets.customAppBar(widget.book.title,
                centerTitle: true, fontSize: 25),
            extendBodyBehindAppBar: true,
            body: SfPdfViewer.asset(
              widget.book.contentPath,
              enableTextSelection: false,
            )));
  }
}
