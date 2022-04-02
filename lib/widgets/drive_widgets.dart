import 'dart:io';

import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/models/google_drive.dart';
import 'package:al_ashraf/models/instruction.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';

import 'loading_widget.dart';

class DriveContentWidget extends StatelessWidget {
  DriveContentWidget(
      {required this.driveFolder, required this.contentViewWidget});

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
            minFontSize: 20,
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
                child: FolderGridCard(
                    folderName: driveContent.content[index].name),
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

class FolderGridCard extends StatelessWidget {
  const FolderGridCard({
    Key? key,
    required this.folderName,
  }) : super(key: key);

  final String folderName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.folder,
          size: MediaQuery.of(context).size.width * 0.28,
          color: Color(0xFFFFCF66),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8),
            child: Text(
              folderName,
              softWrap: true,
              textDirection: TextDirection.rtl,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 20),
            ),
          ),
        )
      ],
    );
  }
}

class DownloadShareButtons extends StatelessWidget {
  DownloadShareButtons({
    required this.driveFile,
    this.rowMainAligment = MainAxisAlignment.spaceBetween,
    this.rowCrossAligment = CrossAxisAlignment.start,
    this.colMainAligment = MainAxisAlignment.start,
  });

  GoogleDrive driveFile;
  MainAxisAlignment rowMainAligment;
  CrossAxisAlignment rowCrossAligment;
  MainAxisAlignment colMainAligment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: rowMainAligment,
      crossAxisAlignment: rowCrossAligment,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              if(Platform.isAndroid){
                Instructions(
                    instructionKey: 'Downloads',
                    instructionText: 'سيتم إِنشاء مجلد بإِسم أحب محمدا'
                        ' داخل مجلد التحميلات الخاص بالجهاز بك'
                        ' و سوف يحتوى على جميع الملفات المحملة من التطبيق')
                    .checkForInstructions();
              }
              driveFile.download();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.download,
                  size: 25,
                ),
                Text(
                  (int.parse(driveFile.size.toString()) / (1024 * 1024))
                          .ceil()
                          .toString() +
                      ' mb',
                )
              ],
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              driveFile.share();
            },
            icon: Icon(
              Icons.adaptive.share,
            )),
      ],
    );
  }
}
