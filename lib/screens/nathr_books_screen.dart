import 'package:al_ashraf/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:al_ashraf/widgets/book_widgets.dart';
import 'package:al_ashraf/models/book.dart';


class NathrBooksScreen extends StatelessWidget {
  NathrBooksScreen({Key? key}) : super(key: key);

  BookData bookData = BookData(kNathrBookTitles,kNathrBooksPartNames,kNathrBooksCoverPaths,kNathrPdfContentPaths);
  @override
  Widget build(BuildContext context) {
    return BookListScreen(screenTitle: 'كتب النثر', widget: SizedBox(height: 10,), bookData: bookData);
  }
}

