import 'package:flutter/material.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  var _webView;
  bool _isLoading = true;
  var _initialUrl = 'https://alashraf-almahdia.net/';

  void initiateWebView(){
    _webView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: Uri(path: _initialUrl)),
      onLoadStop: (controller, url) {
        print(url);
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
   initiateWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black12,
        centerTitle: true,
        title: Text(
          "المقالات",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green),
          textDirection: TextDirection.rtl,
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _webView,
    );
  }
}
