import 'dart:async';

import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/models/post.dart';
import 'package:al_ashraf/models/url_launcher.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  PostData _postData = PostData();
  Post currentPost = Post(url: kMainPostUrl);
  final Completer<WebViewController> _completeController =
  Completer<WebViewController>();
  WebViewController? _webViewController;

  bool connectionState = true;

  Future<bool> _goBack() async {
    var status = await _webViewController!.canGoBack();
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

  @override
  void initState() {
    //_postData.getFavouritePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Provider.of<PostData>(context).getFavouritePosts();
    return SafeArea(
      child: Scaffold(
          appBar: CustomWidgets.customAppBar('المقالات',
              elevation: 0,
              appBarColor: Colors.black12,
              titleTextColor: Colors.green,
              iconColor: Colors.green),
          extendBodyBehindAppBar: true,
          floatingActionButton: FloatingActionButton(
            child: Icon(
              CupertinoIcons.heart_fill,
              color: _postData
                  .getPostByUrl(currentPost.url)
                  .isFavourite
                  ? Colors.green
                  : Colors.grey,
              size: 30,
            ),
            heroTag: 'mainScreen',
            backgroundColor: Colors.white,
            onPressed: () {
              setState(() {
                _postData.updatePostFavouriteStatus(currentPost.url);
              });
            },
          ),
          body: WillPopScope(
              onWillPop: () => _goBack(),
              child: WebView(
                initialUrl: kMainPostUrl,
                gestureNavigationEnabled: true,
                onWebViewCreated: (controller) {
                  _completeController.complete(controller);
                  _webViewController = controller;
                },
                navigationDelegate: (navigation) async{
                  var connectionState = await  _checkConnectivity();
                  if(connectionState){
                    //print('value'+value.toString());
                    if(navigation.url.contains(kMainPostUrl)){
                      return NavigationDecision.navigate;
                    }else{
                      UrlLauncher(navigation.url);
                      return NavigationDecision.prevent;
                    }
                  }else{
                    Get.showSnackbar(CustomWidgets.customSnackBar('تأكد من اتصالك بالأنترنت'));
                    return NavigationDecision.prevent;
                  }

                },
                onPageStarted: (url) {
                  setState(() {
                    currentPost.url = url;
                  });
                },
                onWebResourceError: (error) {
                    Get.to(NoConnectionWidget(restartConnection: (){}));
                    //Get.showSnackbar(CustomWidgets.customSnackBar('تأكد من اتصالك بالأنترنت'));
                },
              ))
      ),
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
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20),
            ),
            style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all(Colors.green)),
          )
        ],
      ),
    );
  }


}
