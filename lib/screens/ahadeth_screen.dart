import 'package:flutter/material.dart';
import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/widgets/audio_widgets.dart';

class AhadethScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AudioFoldersScreen(
      folderRootId: kAhadethRootFolderId,
      screenTitle: 'الأحاديث',
    );
  }
}


