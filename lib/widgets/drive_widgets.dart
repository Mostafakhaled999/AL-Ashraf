import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/models/google_drive.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'loading_widget.dart';

class DriveContentWidget extends StatelessWidget {
  DriveContentWidget(
      {required this.driveFolder,
      required this.contentViewWidget});

  GoogleDrive driveFolder;
  Function contentViewWidget;
  DriveContent driveContent = DriveContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: FutureBuilder(
        future: driveContent.getDriveContent(driveFolder),
        builder: (context, AsyncSnapshot<bool?> snapshot) {
          if (snapshot.hasData) {
            if (driveContent.contentType == kFolderDriveType) {
              return DriveFoldersScreen(
                driveFolder: driveFolder,
                driveContent: driveContent,
                contentViewWidget: contentViewWidget,
              );
            } else {
              return contentViewWidget(driveFolder, driveContent);
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
  GoogleDrive driveFolder;
  DriveContent driveContent;
  Function contentViewWidget;

  DriveFoldersScreen(
      {required this.driveFolder,
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
            child: NewAppBar(screenTitle: driveFolder.name),
          ),
        ])),
        FolderGridList(
          driveContent: driveContent,
          onPress: (index) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DriveContentWidget(
                    driveFolder: driveContent.content[index],
                    contentViewWidget: contentViewWidget,
                  ),
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
  DriveContent driveContent;
  Function onPress;

  FolderGridList({required this.driveContent, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
          (context, index) => GestureDetector(
                child: Column(
                  children: [
                    Icon(
                      Icons.folder,
                      size: MediaQuery.of(context).size.width * 0.28,
                      color: Color(0xFFFFCF66),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8),
                        child: AutoSizeText(
                          driveContent.content[index].name,
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
          childCount: driveContent.contentLength),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
