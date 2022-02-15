import 'package:al_ashraf/widgets/audio_widgets.dart';
import 'package:al_ashraf/widgets/drive_widgets.dart';
import 'package:flutter/material.dart';
import 'package:al_ashraf/constants/constants.dart';

class InshadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DriveContentWidget(
      rootFolderId: kInshadDriveFolderId,
      contentViewWidget: (rooFolderId, scrrenTitle, data) => AudioCardsScreen(
          folderId: rooFolderId, folderName: scrrenTitle, audioData: data),
      screenTitle: 'الإنشاد',
    );
  }
}
