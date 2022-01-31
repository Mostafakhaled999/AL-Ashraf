import 'package:al_ashraf/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:al_ashraf/widgets/book_widgets.dart';
import 'package:al_ashraf/models/book.dart';
import 'package:al_ashraf/widgets/search_widgets.dart';

class DiwanBooksScreen extends StatelessWidget {
  DiwanBooksScreen({Key? key}) : super(key: key);

  BookData bookData = BookData(kDiwanBookTitles,kDiwanPartNames,kDiwanCoverPaths,kDiwanPdfContentPaths);
  @override
  Widget build(BuildContext context) {
    return BookListScreen(screenTitle: 'الدواوين', widget: SearchBar(bookData: bookData,), bookData: bookData);
  }
}

