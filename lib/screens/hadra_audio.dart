import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/models/google_drive.dart';
import 'package:al_ashraf/widgets/audio_widgets.dart';
import 'package:al_ashraf/widgets/drive_widgets.dart';
import 'package:flutter/material.dart';

class HadraAudioScreen extends StatelessWidget {
  GoogleDrive hadraDriveFolder = GoogleDrive(name:'صوت الحضرة',id: kHadraAudioDriveFolderId,type: kFolderDriveType  ,root: true,parent: null);
  @override
  Widget build(BuildContext context) {
    return DriveContentWidget(
      driveFolder: hadraDriveFolder,
      contentViewWidget: (folder,data)=>AudioCardsScreen(driveFolder:folder, audioData: data),
    );
  }
}
