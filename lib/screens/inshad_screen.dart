import 'package:flutter/material.dart';
import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/widgets/audio_widgets.dart';


class InshadScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AudioFoldersScreen(
      folderRootId: kInshadRootFolderId,
      screenTitle: 'الإنشاد',
    );
  }
}