import 'package:webview_flutter/webview_flutter.dart';
import 'package:al_ashraf/models/book.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';

class IOSBookSearchViewScreen extends StatefulWidget {
  Book book;

  IOSBookSearchViewScreen({required this.book});

  @override
  _IOSBookSearchViewScreenState createState() =>
      _IOSBookSearchViewScreenState();
}

class _IOSBookSearchViewScreenState extends State<IOSBookSearchViewScreen> {
  final Completer<WebViewController> _completeController =
      Completer<WebViewController>();
  WebViewController? _webViewController;

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

          ),
          // CustomWidgets.customAppBar(widget.book.title,
          //     fontSize: 23, elevation: 1),
          extendBodyBehindAppBar: true,
          extendBody: true,
          body: GestureDetector(
              onLongPress: () {},
              child: WebView(javascriptMode: JavascriptMode.unrestricted,  onWebViewCreated: (controller) {
                _completeController.complete(controller);
                _webViewController = controller;
                controller.loadHtmlString(widget.book.IOSWebViewContent.replaceFirst(widget.book.completeSearchText.toString(), '<mark>${widget.book.completeSearchText}</mark>'));

              },onPageFinished: (url){
                //_webViewController!.loadHtmlString(widget.book.webViewContent.replaceFirst(widget.book.searchQuery.toString(), '<mark>${widget.book.searchQuery}</mark>'));
                _webViewController!.runJavascript('window.scrollBy(0, document.evaluate("//*[text()[contains(., \'${widget.book.completeSearchText}\')]]", document.body).iterateNext().getBoundingClientRect().top);');
              },)

          ),
        ));
  }
}
