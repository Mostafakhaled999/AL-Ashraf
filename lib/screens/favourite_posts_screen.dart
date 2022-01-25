import 'package:al_ashraf/models/post.dart';
import 'package:al_ashraf/widgets/blurry_back_ground.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:al_ashraf/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:al_ashraf/constants/constants.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

class FavouritePostsScreen extends StatelessWidget {
  FavouritePostsScreen({Key? key}) : super(key: key);
  PostData _postData = PostData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidgets.customAppBar(
        'المقالات المفضلة',
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          BlurryBackGround(backGroundImgPath: kAlkobbaBGImgPath),
          Container(
              color: Colors.transparent,
              child: FutureBuilder(
                future: _postData.getFavouritePosts(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (_postData.count == 0) {
                      return Center(
                        child: Text(
                          'لا يوجد مقالات مفضلة',
                          style: TextStyle(fontSize: 30, color: Colors.white),
                          textDirection: TextDirection.rtl,
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          var favPost = _postData.posts[index];
                          return Dismissible(
                            key: Key(favPost.url),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (direction) {
                              _postData.removeFromFavourites(favPost);
                            },
                            child: FavouritePostCard(
                                favPost: favPost,),
                          );
                        },
                        itemCount:_postData.count,
                      );
                    }
                  } else
                    return LoadingWidget();
                },
              )
              )
        ],
      ),
    );
  }
}

class FavouritePostViewer extends StatelessWidget {
  Post favPost;

  FavouritePostViewer({required this.favPost});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CustomWidgets.customAppBar(favPost.title!),
      extendBodyBehindAppBar: true,
      body: GestureDetector(
          onTap: () {},
          child: InAppWebView(
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
              supportZoom: true,
              javaScriptEnabled: true,
              horizontalScrollBarEnabled: true,
              useShouldOverrideUrlLoading: true,
            )),
            onWebViewCreated: (controller) {
              controller.loadData(data: favPost.htmlContent!);
            },
            onLoadError: (controller, url, code, message) {
              Get.showSnackbar(CustomWidgets.customSnackBar('حدث خطأ حاول لاحقا'));
              Get.back();
            },
          )),
    ));
  }
}
class FavouritePostCard extends StatelessWidget {
  Post favPost;
  FavouritePostCard({required this.favPost});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(()=>FavouritePostViewer(
          favPost: favPost,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          height: 120,
          child: Card(
            elevation: 10,
            color: Color(0xFFF1F2F6), //#F1F2F6
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child:  ListTile(
                      isThreeLine: true,
                      // dense: true,
                      title: Row(
                          textDirection: TextDirection.rtl,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  CupertinoIcons.heart_fill,
                                  color: Colors.green,
                                )),
                            Text(
                              "احب محمدا ",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ]),
                      subtitle: Column(
                        textDirection: TextDirection.rtl,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 40,
                            child: Marquee(
                              text: "${favPost.title}   ",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                              numberOfRounds: 4,
                              //velocity: 50,
                            ),
                          ),
                          Text("${favPost.date}",textDirection: TextDirection.rtl,)

                        ],
                      )
                  ),

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
