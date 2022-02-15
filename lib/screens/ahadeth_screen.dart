import 'package:al_ashraf/widgets/audio_widgets.dart';
import 'package:flutter/material.dart';
import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/widgets/drive_widgets.dart';

class AhadethScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DriveContentWidget(
      rootFolderId: kAhadethDriveFolderId,
      contentViewWidget: (rooFolderId, scrrenTitle, data) => AudioCardsScreen(
          folderId: rooFolderId, folderName: scrrenTitle, audioData: data),
      screenTitle: 'الأحاديث',
    );
  }
}
