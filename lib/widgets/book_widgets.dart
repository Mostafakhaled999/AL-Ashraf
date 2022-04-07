import 'dart:async';
import 'dart:io';
import 'package:al_ashraf/models/instruction.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:al_ashraf/models/book.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class BookListScreen extends StatelessWidget {
  String screenTitle;
  Widget widget;
  BookData bookData;

  BookListScreen({required this.screenTitle,
    required this.widget,
    required this.bookData});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.adaptive.arrow_back),
                            iconSize: 40,
                            //textDirection: TextDirection.ltr,
                            color: Colors.black,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Text(
                            screenTitle,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                fontSize: 45, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    widget,
                  ])),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return BookCard(bookData.books[index]);
                }, childCount: bookData.count),
              )
            ],
          ),
        ));
  }
}

class BookCard extends StatelessWidget {
  Book book;

  BookCard(this.book);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 12, left: 12),
      child: GestureDetector(
        onTap: () {
          Get.to(() =>
              PdfViewerScreen(
                book: book,
              ));
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          height: 150,
          width: double.infinity,
          color: Color(0xFFFAFAFA),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            textDirection: TextDirection.rtl,
            children: <Widget>[
              Container(
                height: 150,
                width: 0.28 * MediaQuery
                    .of(context)
                    .size
                    .width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(book.coverPath),
                    ),
                    color: Color(0xFFFAFAFA)),
              ),
              SizedBox(
                width: 15,
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AutoSizeText(
                        book.title,
                        maxLines: 1,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF121212)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      AutoSizeText(
                        book.partName,
                        maxLines: 1,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF121212)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        book.authorName,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFAAAAAA)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PdfViewerScreen extends StatefulWidget {
  Book book;

  PdfViewerScreen({required this.book});

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  static const _pdfInstructionKey = 'PdfInstructions';
  static const _pdfInstructionText = "للإنتقال إلى صفحة محددة"
      " اضغط على رقم الصفحة فى الجانب الأيمن"
      " ثم اكتب رقم الصفحة";

  Instructions instructions = Instructions(
      instructionKey: _pdfInstructionKey, instructionText: _pdfInstructionText);

  @override
  void initState() {
    instructions.checkForInstructions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Stack(
              children: [
                SfPdfViewer.asset(
                  widget.book.pdfContentPath,
                  enableTextSelection: false,
                ),
                Positioned(
                  height: 50,
                  width: 50,
                  top: 10,
                  left: 10,
                  child: Card(
                      elevation: 5,
                      color: Colors.lightGreen,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: IconButton(
                        icon: Icon(
                          Icons.adaptive.arrow_back,
                          size: 25,
                          color: Colors.white,
                        ),
                        //color: Colors.green,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )),
                ),
              ],
            )));
  }
}

class AndroidBookSearchViewScreen extends StatefulWidget {
  Book book;

  AndroidBookSearchViewScreen({required this.book});

  @override
  _AndroidBookSearchViewScreenState createState() => _AndroidBookSearchViewScreenState();
}

class _AndroidBookSearchViewScreenState extends State<AndroidBookSearchViewScreen> {
  late InAppWebViewController _webViewController;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              widget.book.title,
              textDirection: TextDirection.rtl,
            ),
            titleTextStyle: TextStyle(
                color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
            leading: IconButton(
              icon: Icon(
                Icons.adaptive.arrow_back,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
               // _webViewController.clearFocus();
                Get.back();
              },
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    //_webViewController.findNext(forward: false);
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_up,
                    size: 30,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {
                    //_webViewController.findNext(forward: true);
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 30,
                    color: Colors.white,
                  )),
            ],
          ),
          // CustomWidgets.customAppBar(widget.book.title,
          //     fontSize: 23, elevation: 1),
          extendBodyBehindAppBar: true,
          extendBody: true,
          body: GestureDetector(
            onLongPress: () {},
            child:InAppWebView(
                  initialData:
                  InAppWebViewInitialData(data: widget.book.webViewContent),
                  initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        supportZoom: true,
                        javaScriptEnabled: false,
                        horizontalScrollBarEnabled: true,
                      )),
                  onLoadStop: (controller, url) {
                    _webViewController = controller;
                             controller.findAllAsync(
               find: widget.book.completeSearchText.toString());
                  },
                  onFindResultReceived: (controller, activeMatchOrdinal,
                      numberOfMatches, isDoneCounting) {
                    if (isDoneCounting && numberOfMatches == 0) {
                      controller.findAllAsync(
                          find: widget.book.searchQuery.toString());
                    }
                  },
                )

          ),
        ));
  }
}





