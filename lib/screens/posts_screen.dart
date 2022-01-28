import 'dart:async';

import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/models/instruction.dart';
import 'package:al_ashraf/models/post.dart';
import 'package:al_ashraf/models/url_launcher.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:al_ashraf/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class PostsScreen extends StatefulWidget {
  String url;

  PostsScreen({this.url = kMainPostUrl});

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  static const _postsInstructionKey = 'PostsInstructions';
  static const _postsInstructionText = 'لإضافة مقال إلى المقالات المفضلة'
      ' اضغط على عنوان المقال الذى تريده أولا'
      ' ثم اضغط على الدائرة أسفل يمين الشاشة';

  Instructions _postsInstructions = Instructions(
      instructionKey: _postsInstructionKey,
      instructionText: _postsInstructionText);

  PostData _postData = PostData();
  late Post _currentPost =
      Post(url: widget.url == '' ? kMainPostUrl : widget.url);
  final Completer<WebViewController> _completeController =
      Completer<WebViewController>();
  WebViewController? _webViewController;

  late bool _connectionState;

  bool wantToGoBack = false;

  Future<bool> _goBack() async {
    wantToGoBack = true;
    var status = await _webViewController!.canGoBack();
    print('status' + status.toString());
    if (status) {
      _webViewController!.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  Future<bool> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

  Future<NavigationDecision> _checkConnectionForNavigation(
      NavigationRequest navigation) async {
    _connectionState = await _checkConnectivity();
    print('navigation');
    if (_connectionState) {
      if (navigation.url.contains(kMainPostUrl)) {
        return NavigationDecision.navigate;
      } else {
        UrlLauncher(navigation.url);
        return NavigationDecision.prevent;
      }
    } else {
      Get.showSnackbar(
          CustomWidgets.customSnackBar('تأكد من اتصالك بالأنترنت'));
      return NavigationDecision.prevent;
    }
  }

  Future _restartConnection() async {
    _checkConnectivity().then((value) {
      setState(() {
        _connectionState = true;
      });
    });
  }

  @override
  void initState() {
    _postsInstructions.checkForInstructions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: CustomWidgets.customAppBar(
            'المقالات',
            elevation: 1,
          ),
          extendBodyBehindAppBar: true,
          floatingActionButton: FloatingActionButton(
            child: Icon(
              CupertinoIcons.heart_fill,
              color: _currentPost.isFavourite ? Colors.green : Colors.grey,
              size: 30,
            ),
            backgroundColor: Colors.white,
            onPressed: () async {
              _connectionState = await _checkConnectivity();
              await _postData.updatePostFavouriteStatus(_currentPost.url);
              if (_connectionState) {
                setState(() {
                  _currentPost = _postData.getPostByUrl(_currentPost.url);
                });
              }
            },
          ),
          body: FutureBuilder(
            future: _checkConnectivity(),
            builder: (context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData) {
                _connectionState = snapshot.data!;
                if (_connectionState) {
                  return WillPopScope(
                      onWillPop: () => _goBack(),
                      child: WebView(
                        initialUrl: _currentPost.url,
                        gestureNavigationEnabled: true,
                        onWebViewCreated: (controller) {
                          _completeController.complete(controller);
                          _webViewController = controller;
                        },
                        navigationDelegate: (navigation) async {
                          return _checkConnectionForNavigation(navigation);
                        },
                        onPageStarted: (url) async {
                          _connectionState = await _checkConnectivity();
                          if (_connectionState) {
                            setState(() {
                              _currentPost = _postData.getPostByUrl(url);
                            });
                          }
                        },
                        onWebResourceError: (error) {
                          //Get.to(NoConnectionWidget(restartConnection: ()=>_restartConnection()));
                        },
                      ));
                } else {
                  return NoConnectionWidget(
                      restartConnection: () => _restartConnection());
                }
              } else {
                return LoadingWidget();
              }
            },
          )),
    );
  }
}

class NoConnectionWidget extends StatelessWidget {
  Function restartConnection;

  NoConnectionWidget({required this.restartConnection});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.wifi_slash,
            size: 40,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "تأكد من اتصالك بالأنترنت",
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () => restartConnection(),
            child: Text(
              "اعادة تحميل",
              textDirection: TextDirection.rtl,
              softWrap: true,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green)),
          )
        ],
      ),
    );
  }
}
