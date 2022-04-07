import 'package:al_ashraf/constants/constants.dart';
import 'package:flutter/services.dart';
import 'package:epubx/epubx.dart';

class Book {
  String title;
  String partName;
  String? completeSearchText;
  String? searchQuery;
  String coverPath;
  String authorName = 'صلاح الدين القوصى';
  String pdfContentPath;
  String webViewContent;
  String IOSWebViewContent;
  int? partNumber;

  Book({required this.title,
    required this.partName,
    required this.coverPath,
    this.partNumber,
    required this.pdfContentPath,
    this.webViewContent = '',
    this.IOSWebViewContent = ''});
}

class BookData {
  List<Book> books = [];
  EpubBook? epubBookWithTashkil;
  EpubBook? epubBookWithOutTashkil;

  get count {
    return books.length;
  }

  BookData(List<String> titles, List<String> partNames, List<String> coverPaths,
      List<String> contentPaths) {
    for (int i = 0; i < titles.length; i++) {
      var partNumber = i + 1;
      Book book = Book(
          title: titles[i],
          partName: partNames[i],
          pdfContentPath: contentPaths[i],
          partNumber: partNumber,
          coverPath: coverPaths[i]);
      books.add(book);
    }
  }

  Future<void> _loadDiwanEpub() async {
    var data = await rootBundle.load(kDiwanEpubWithOutTashkilPath);
    epubBookWithOutTashkil =
    await EpubReader.readBook(data.buffer.asUint8List());
    data = await rootBundle.load(kDiwanEpubWithTashkilPath);
    epubBookWithTashkil = await EpubReader.readBook(data.buffer.asUint8List());
  }

  Future<List<Book>> search(String searchText) async{
    if(epubBookWithTashkil == null || epubBookWithOutTashkil == null)
      await _loadDiwanEpub();
    try{
      int bookPartIndex;
      List<Book> searchedBooks = [];
      epubBookWithOutTashkil!.Chapters!.forEach((EpubChapter mainChapter) {
        bookPartIndex = epubBookWithOutTashkil!.Chapters!.indexOf(mainChapter);
        mainChapter.SubChapters!.forEach((EpubChapter firstSubChapter) {
          if (firstSubChapter.SubChapters!.isNotEmpty)
            firstSubChapter.SubChapters!.forEach((EpubChapter secondSubChapter) {
              if (secondSubChapter.SubChapters!.isNotEmpty)
                secondSubChapter.SubChapters!
                    .forEach((EpubChapter thirdSubChapter) {
                  if (thirdSubChapter.SubChapters!.isNotEmpty)
                    thirdSubChapter.SubChapters!
                        .forEach((EpubChapter fourthSubChapter) {
                      _extractText(mainChapter, fourthSubChapter, searchText,
                          bookPartIndex, searchedBooks);
                    });
                  else {
                    _extractText(mainChapter, thirdSubChapter, searchText,
                        bookPartIndex, searchedBooks);
                  }
                });
              else {
                _extractText(mainChapter, secondSubChapter, searchText,
                    bookPartIndex, searchedBooks);
              }
            });
          else {
            _extractText(mainChapter, firstSubChapter, searchText, bookPartIndex,
                searchedBooks);
          }
        });
      });
      //print('length: ' + searchedBooks.length.toString());
      return searchedBooks;
    }catch(e){
      return Future.error(e);
    }

  }

  void _extractText(EpubChapter mainChapter, EpubChapter subChapter,
      String searchText, int bookPartIndex, List<Book> searchedBooks) {
    int startSearch = 0;
    String completeSearchText;
    late Book bookResult;
    while (true) {
      var occurrenceIndex =
      subChapter.HtmlContent!.indexOf(searchText, startSearch);
      var strtOccurrenceIndex = occurrenceIndex;
      var endOccurrenceIndex = occurrenceIndex;
      if (occurrenceIndex < 0)
        break;
      else {
        var startChar = subChapter.HtmlContent![occurrenceIndex];
        while (startChar != '>') {
          strtOccurrenceIndex--;
          startChar = subChapter.HtmlContent![strtOccurrenceIndex];
        }
        strtOccurrenceIndex += 1;
        endOccurrenceIndex =
            subChapter.HtmlContent!.indexOf('<', occurrenceIndex);

        completeSearchText = subChapter.HtmlContent!
            .substring(strtOccurrenceIndex, endOccurrenceIndex);
        bookResult = Book(title: subChapter.Title.toString(),
            partName: books[bookPartIndex].partName,
            coverPath: books[bookPartIndex].coverPath,
            pdfContentPath: books[bookPartIndex].pdfContentPath);
        bookResult.completeSearchText = completeSearchText;
        bookResult.searchQuery = searchText;
        bookResult.webViewContent =
            epubBookWithTashkil!.Content!.Html![subChapter.ContentFileName]!
                .Content.toString();
        bookResult.IOSWebViewContent =
            epubBookWithOutTashkil!.Content!.Html![subChapter.ContentFileName]!
                .Content.toString();
        searchedBooks.add(bookResult);
      }
      startSearch = endOccurrenceIndex + 1;
      if (startSearch >= subChapter.HtmlContent!.length) break;
    }
  }
}
