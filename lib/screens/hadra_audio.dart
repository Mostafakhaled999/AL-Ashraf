import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/widgets/audio_widgets.dart';
import 'package:al_ashraf/widgets/drive_widgets.dart';
import 'package:flutter/material.dart';

class HadraAudioScreen extends StatelessWidget {
  const HadraAudioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DriveContentWidget(
      rootFolderId: kHadraAudioDriveFolderId,
      contentViewWidget: (rooFolderId,scrrenTitle,data)=>AudioCardsScreen(folderId: rooFolderId, folderName: scrrenTitle, audioData: data),
      screenTitle: 'صوت الحضرة',
    );
  }
}
