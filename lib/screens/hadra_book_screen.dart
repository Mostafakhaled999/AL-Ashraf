import 'package:al_ashraf/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:al_ashraf/widgets/pdf.dart';

class HadraBookScreen extends StatelessWidget {
  const HadraBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PdfViewerScreen(bookPath: 'assets/books/pdf/hadra/hadra_book.pdf');
  }
}
