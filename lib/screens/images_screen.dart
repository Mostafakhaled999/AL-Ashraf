import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/models/google_drive.dart';
import 'package:al_ashraf/widgets/cards.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:al_ashraf/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:al_ashraf/widgets/drive_widgets.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class ImagesScreen extends StatelessWidget {
  GoogleDrive imagesDriveFolder = GoogleDrive(name:'الصور',id: kImagesDriveFolderId,type: kFolderDriveType ,root: true,parent: null );

  @override
  Widget build(BuildContext context) {
    return DriveContentWidget(
       driveFolder:imagesDriveFolder ,
        contentViewWidget: (folder, data) => ImageCardsScreen(
           driveFolder: folder, imageData: data));
  }
}

class FullSizeScreenImage extends StatelessWidget {

  String imageId;

  FullSizeScreenImage(this.imageId);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CustomWidgets.customAppBar(''),
        body: Container(
            child: PhotoView(
          imageProvider: NetworkImage(kViewDriveContentUrl + imageId),
        )),
      ),
    );
  }
}

class ImageCardsScreen extends StatelessWidget {
 GoogleDrive driveFolder;
  DriveContent imageData;

  ImageCardsScreen(
      {required this.driveFolder,
      required this.imageData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: CustomWidgets.customAppBar(driveFolder.name, appBarColor: Colors.green),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              return GridCard(
                gridCardImage: _cardImage(index),
                gridCardWidget: _cardWidget(index),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                onPress: () {
                  Get.to(
                      () => FullSizeScreenImage(imageData.content[index].id));
                },
              );
            }, childCount: imageData.contentLength),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 15,
            ),
          )
        ],
      ),
    );
  }

  Row _cardWidget(int index) {
    return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      imageData.content[index].download();
                    },
                    icon: Icon(Icons.download),
                  ),
                  IconButton(
                      onPressed: () {
                        imageData.content[index].share();
                      },
                      icon: Icon(Icons.adaptive.share)),
                ],
              );
  }

  ClipRRect _cardImage(int index) {
    return ClipRRect(
                child: Image(
                  fit: BoxFit.fitWidth,
                  alignment: AlignmentDirectional.topStart,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return LoadingWidget();
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error);
                  },
                  image: NetworkImage(
                      kViewDriveContentUrl + imageData.content[index].id),
                ),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              );
  }
}
