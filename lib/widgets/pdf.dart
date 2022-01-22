import 'package:flutter/material.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatefulWidget {
  String bookPath;

  PdfViewerScreen({required this.bookPath});

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: CustomWidgets.customAppBar('الحضرة كاملة الطبعة 29',
                centerTitle: true, fontSize: 25),
            extendBodyBehindAppBar: true,
            body: SfPdfViewer.asset(
              widget.bookPath,
              enableTextSelection: false,
            )));
  }
}
