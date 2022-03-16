import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/models/book.dart';
import 'package:al_ashraf/widgets/book_widgets.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:al_ashraf/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBar extends StatelessWidget {
  BookData bookData;

  SearchBar({required this.bookData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Container(
        height: 39,
        margin: EdgeInsets.only(left: 25, right: 25, top: 18),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.grey[300]),
        child: Stack(
          children: <Widget>[
            TextField(
              //enabled: false,
              readOnly: true,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 19, right: 55, bottom: 8),
                  border: InputBorder.none,
                  hintText: 'بحث ..',
                  hintTextDirection: TextDirection.rtl,
                  hintStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600)),
              onTap: () {
                showSearch(
                  context: context,
                  delegate: SearchScreen(bookData),
                );
              },
            ),
            Positioned(
              right: 0,
              child: Image(
                image: AssetImage(kBackGroundSrchBarImgPath),
                color: Colors.green[400],
              ),
            ),
            Positioned(
              top: 8,
              right: 9,
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SearchScreen extends SearchDelegate<String> {
  BookData bookData;

  SearchScreen(this.bookData);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: transitionAnimation,
          ))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, query);
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    return query.isNotEmpty? FutureBuilder(
          future: bookData.search(query),
          builder: (context,AsyncSnapshot<List<Book>> snapshot) {
            if (snapshot.hasData) {
              var booksResult = snapshot.data!;
              if (booksResult.length != 0) {
                return ListView.builder(
                  itemCount: booksResult.length,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return SearchBookTile(
                      query: query,
                      book: booksResult[index],
                    );
                  },
                );
              } else {
                return ResultsNotFound();
              }
            } else if(snapshot.hasError) {
              Get.back();
              return CustomWidgets.customSnackBar('حدث خطأ حاول لاحقا');

            }
            else
              return LoadingWidget();
          }):ResultsNotFound();

    }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

class SearchBookTile extends StatelessWidget {
  const SearchBookTile({
    Key? key,
    required this.query,
    required this.book,
  }) : super(key: key);

  final String query;
  final Book book;

  @override
  Widget build(BuildContext context) {
    String completeSearchText = book.completeSearchText!;
    return ListTile(
      tileColor: Colors.white,
      minVerticalPadding: 15,
      isThreeLine: true,
      title: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: completeSearchText.substring(
                  0, completeSearchText.indexOf(query)),
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w400)),
          TextSpan(
              text: completeSearchText.substring(
                  completeSearchText.indexOf(query),
                  completeSearchText.indexOf(query) + query.length),
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                  fontWeight: FontWeight.w900)),
          TextSpan(
              text: completeSearchText.substring(
                completeSearchText.indexOf(query) + query.length,
                completeSearchText.length,
              ),
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w400))
        ]),
        textDirection: TextDirection.rtl,
        softWrap: true,
      ),
      subtitle: Text(
        book.title,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontSize: 17,
        ),
        softWrap: true,
      ),
      trailing: Image(
        image: AssetImage(book.coverPath),
        fit: BoxFit.fitHeight,
      ),
      onTap: () {
        Get.to(() => WebViewViewerScreen(book: book));
      },
    );
  }
}

class ResultsNotFound extends StatelessWidget {
  const ResultsNotFound({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      'لا توجد نتائج',
      style: TextStyle(fontSize: 25),
    ));
  }
}
