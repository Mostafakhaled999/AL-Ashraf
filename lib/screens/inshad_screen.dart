import 'package:al_ashraf/models/google_drive.dart';
import 'package:al_ashraf/widgets/audio_widgets.dart';
import 'package:al_ashraf/widgets/drive_widgets.dart';
import 'package:flutter/material.dart';
import 'package:al_ashraf/constants/constants.dart';

class InshadScreen extends StatelessWidget {
  GoogleDrive inshadDriveFolder = GoogleDrive(name: 'الإنشاد',id: kInshadDriveFolderId,type: kFolderDriveType ,root: true,parent: null );
  @override
  Widget build(BuildContext context) {
    return DriveContentWidget(
      driveFolder: inshadDriveFolder,
      contentViewWidget: (folder, data) => AudioCardsScreen(
          driveFolder: folder, audioData: data),
    );
  }
}
