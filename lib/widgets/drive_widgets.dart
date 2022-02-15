import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/models/google_drive.dart';
import 'package:al_ashraf/widgets/audio_widgets.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'loading_widget.dart';


class DriveContentWidget extends StatelessWidget {
  DriveContentWidget(
      {required this.rootFolderId, required this.screenTitle, required this.contentViewWidget});

  String screenTitle;
  String rootFolderId;
  Function contentViewWidget;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: FutureBuilder(
            future: GoogleDrive().getDriveContent(rootFolderId, true),
            builder: (context, AsyncSnapshot<DriveContent?>snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.contentType == kFolderDriveType) {
                  return DriveFoldersScreen(folderRootId: rootFolderId,
                    screenTitle: screenTitle,
                    driveContent: snapshot.data!,
                    contentViewWidget: contentViewWidget,);
                } else {
                  return contentViewWidget(
                      rootFolderId, screenTitle, snapshot.data!);
                }
              } else {
                return LoadingWidget();
              }
            },
          ),
        ));
  }
}

class DriveFoldersScreen extends StatelessWidget {
  String folderRootId;
  String screenTitle;
  DriveContent driveContent;
  Function contentViewWidget;

  DriveFoldersScreen({required this.folderRootId,
    required this.screenTitle,
    required this.driveContent,
    required this.contentViewWidget});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.all(12),
                child: NewAppBar(screenTitle: screenTitle),
              ),
            ])),
        FolderGridList(
          folderNames: driveContent.contentNames,
          folderIds: driveContent.contentIds,
          onPress: (index) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DriveContentWidget(
                        rootFolderId: driveContent.contentIds[index],
                        screenTitle: driveContent.contentNames[index],
                        contentViewWidget: contentViewWidget,),
                ));
          },
        )
      ],
    );
  }
}

class NewAppBar extends StatelessWidget {
  const NewAppBar({
    Key? key,
    required this.screenTitle,
  }) : super(key: key);

  final String screenTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.adaptive.arrow_back),
          iconSize: 40,
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Expanded(
          child: AutoSizeText(
            screenTitle,
            textDirection: TextDirection.rtl,
            maxLines: 1,
            minFontSize: 25,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class FolderGridList extends StatelessWidget {

  List<String> folderNames;
  List<String> folderIds;
  Function onPress;

  FolderGridList(
      {required this.folderNames, required this.folderIds, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
              (context, index) =>
              GestureDetector(
                child: Column(
                  children: [
                    Icon(
                      Icons.folder,
                      size: MediaQuery
                          .of(context)
                          .size
                          .width *
                          0.28,
                      color: Color(0xFFFFCF66),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8),
                        child: AutoSizeText(
                          folderNames[index],
                          softWrap: true,
                          textDirection: TextDirection.rtl,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
                onTap: () => onPress(index),
              ),
          childCount: folderNames.length),
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
