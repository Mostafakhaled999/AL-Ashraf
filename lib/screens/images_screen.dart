import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/models/google_drive.dart';
import 'package:al_ashraf/widgets/cards.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:al_ashraf/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:al_ashraf/widgets/drive_widgets.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImagesScreen extends StatelessWidget {
  const ImagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DriveContentWidget(
        rootFolderId: kImagesDriveFolderId,
        screenTitle: 'الصور',
        contentViewWidget: (rooFolderId, scrrenTitle, data) => ImageCardsScreen(
            folderId: rooFolderId, folderName: scrrenTitle, imageData: data));
  }
}

class ImageCardsScreen extends StatelessWidget {
  String folderId;
  String folderName;
  DriveContent imageData;

  ImageCardsScreen(
      {required this.folderId,
      required this.folderName,
      required this.imageData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: CustomWidgets.customAppBar(
        folderName,
        appBarColor: Colors.green
      ),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
                    (context, index) {
              return GridCard(
                gridCardImage:
                   ClipRRect(
                     child: Image(
                      fit: BoxFit.fitWidth,
                      alignment: AlignmentDirectional.topStart,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return LoadingWidget();
                      },
                      image: NetworkImage(
                          kViewDriveContentUrl + imageData.contentIds[index]),
                  ),
                     borderRadius: const BorderRadius.only(
                         topLeft: Radius.circular(15),
                         topRight: Radius.circular(15)),
                   ),
                gridCardWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(onPressed: (){}, icon: Icon(Icons.download),),
                    IconButton(onPressed: (){}, icon: Icon(Icons.adaptive.share)),
                  ],
                ),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                onPress: (){},
              );
            },
              childCount:imageData.contentLength),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 15,
            ),
          )
        ],
      ),
    );
  }
}
