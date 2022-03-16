import 'package:al_ashraf/models/book.dart';
import 'package:al_ashraf/models/google_drive.dart';
import 'package:al_ashraf/widgets/audio_widgets.dart';
import 'package:al_ashraf/widgets/book_widgets.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:al_ashraf/widgets/drive_widgets.dart';
import 'package:flutter/material.dart';
import 'package:al_ashraf/widgets/cards.dart';
import 'package:al_ashraf/constants/constants.dart';
import 'package:lottie/lottie.dart';

class HadraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomWidgets.customAppBar('الحضرة', appBarColor: Colors.green),
        body: CustomScrollView(
          slivers: [
            CardGridList(
              gridCardNames: kHadraScreenCardNames,
              gridCardImages: (index) => Lottie.asset(
                  kHadraAnimatedHomeImgsPath[index],
                  fit: BoxFit.cover),
              onPress: (index) => Navigator.pushNamed(
                  context, kHadraScreenRouteNames[index]),
            ),
          ],
        ));
  }
}

class HadraBookScreen extends StatelessWidget {
  HadraBookScreen({Key? key}) : super(key: key);
  Book hadraBook = Book(title: 'الحضرة كاملة الطبعة 29',pdfContentPath: kHadraBookPath,coverPath: kHadraBookCoverPath,partName: ' الطبعة 29');

  @override
  Widget build(BuildContext context) {
    return PdfViewerScreen(book: hadraBook);
  }
}

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

