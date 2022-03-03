import 'package:al_ashraf/models/google_drive.dart';
import 'package:al_ashraf/widgets/audio_widgets.dart';
import 'package:flutter/material.dart';
import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/widgets/drive_widgets.dart';

class AhadethScreen extends StatelessWidget {
  GoogleDrive ahadethDriveFolder = GoogleDrive(name:'الأحاديث',id: kAhadethDriveFolderId,type: kFolderDriveType ,root: true,parent: null);
  @override
  Widget build(BuildContext context) {
    return DriveContentWidget(
      driveFolder:ahadethDriveFolder ,
      contentViewWidget: (folder, data) => AudioCardsScreen(
          driveFolder: folder, audioData: data),
    );
  }
}
