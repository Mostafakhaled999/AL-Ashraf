class Book {
  String title;
  String partName;
  String? searchText;
  String coverPath;
  String authorName = 'صلاح الدين القوصى';
  String contentPath;
  int? partNumber;

  Book(
      {required this.title,
      required this.partName,
      required this.coverPath,
      this.partNumber,
      required this.contentPath,
      this.searchText});
}

class BookData {
  List<Book> books = [];

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
          contentPath: contentPaths[i],
          partNumber: partNumber,
          coverPath: coverPaths[i]);
      books.add(book);
    }
  }
}
