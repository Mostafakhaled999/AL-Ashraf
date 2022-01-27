import 'package:al_ashraf/models/instruction.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:al_ashraf/models/book.dart';
import 'package:get/get.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/src/material/search.dart';

class BookListScreen extends StatelessWidget {
  String screenTitle;
  Widget widget;
  BookData bookData;

  BookListScreen(
      {required this.screenTitle,
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
                    style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
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
          Get.to(()=>PdfViewerScreen(
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
                width: 0.28 * MediaQuery.of(context).size.width,
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

  Instructions instructions = Instructions(instructionKey: _pdfInstructionKey, instructionText: _pdfInstructionText);

  @override
  void initState() {
    // TODO: implement initState
    instructions.checkForInstructions();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: CustomWidgets.customAppBar(widget.book.title,
                centerTitle: true, fontSize: 25,elevation: 1),
            extendBodyBehindAppBar: true,
            body: SfPdfViewer.asset(
              widget.book.pdfContentPath,
              enableTextSelection: false,
            )));
  }
}

class WebViewViewerScreen extends StatefulWidget {
  Book book;

  WebViewViewerScreen({required this.book});

  @override
  _WebViewViewerScreenState createState() => _WebViewViewerScreenState();
}

class _WebViewViewerScreenState extends State<WebViewViewerScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CustomWidgets.customAppBar(widget.book.title,fontSize: 23,elevation: 1),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: GestureDetector(
        onLongPress: (){},
        child: InAppWebView(
          initialData: InAppWebViewInitialData(data: widget.book.webViewContent),
          initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
            supportZoom: true,
            javaScriptEnabled: false,
            horizontalScrollBarEnabled: true,
          )),
          onLoadStop: (controller, url) {
            controller.findAllAsync(find: widget.book.searchText.toString());
          },
        ),
      ),
    ));
  }
}
