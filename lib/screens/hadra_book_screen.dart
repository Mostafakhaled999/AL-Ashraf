import 'package:al_ashraf/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:al_ashraf/widgets/book_widgets.dart';
import 'package:al_ashraf/models/book.dart';

class HadraBookScreen extends StatelessWidget {
  HadraBookScreen({Key? key}) : super(key: key);
  Book hadraBook = Book(title: 'الحضرة كاملة الطبعة 29',pdfContentPath: kHadraBookPath,coverPath: kHadraBookCoverPath,partName: ' الطبعة 29');

  @override
  Widget build(BuildContext context) {
    return PdfViewerScreen(book: hadraBook);
  }
}
