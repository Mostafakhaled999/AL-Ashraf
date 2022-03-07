import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/models/google_drive.dart';
import 'package:al_ashraf/widgets/book_widgets.dart';
import 'package:al_ashraf/widgets/cards.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:al_ashraf/widgets/drive_widgets.dart';
import 'package:al_ashraf/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AzkarAndSalwat extends StatelessWidget {
  GoogleDrive azkar_slawat = GoogleDrive(
      name: 'الأوراد والأذكار',
      id: kAzkarAndSlawatDriveFolderId,
      type: kFolderDriveType,
      parent: null,
      root: true);

  @override
  Widget build(BuildContext context) {
    return DriveContentWidget(
      driveFolder: azkar_slawat,
      contentViewWidget: (folder, data) =>
          DriveBooksScreen(driveFolder: folder, bookData: data),
    );
  }
}

class DriveBooksScreen extends StatelessWidget {
  GoogleDrive driveFolder;
  DriveContent bookData;

  DriveBooksScreen({required this.driveFolder, required this.bookData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: CustomWidgets.customAppBar(driveFolder.name,
          appBarColor: Colors.green),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              return GridCard(
                gridCardImage: _cardImage(index),
                gridCardWidget: ImageCardText(
                  gridCardName: bookData.content[index].name,
                  cardNameMaxLines: 1,
                  cardNameFontSize: 20,
                ),
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                onPress: () {
                  Get.to(() => DriveBookView(
                      bookViewLink: bookData.content[index].mainLink!));
                },
              );
            }, childCount: bookData.contentLength),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 15,
            ),
          )
        ],
      ),
    );
  }

  ClipRRect _cardImage(int index) {
    return ClipRRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image(
            fit: BoxFit.cover,
            alignment: AlignmentDirectional.topStart,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return LoadingWidget();
            },
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error);
            },
            image: NetworkImage(bookData.content[index].thumbnail!),
          ),
          DownloadShareButtons(
            driveFile: bookData.content[index],
            rowMainAligment: MainAxisAlignment.spaceBetween,
          ),
        ],
      ),
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15), topRight: Radius.circular(15)),
    );
  }
}

class DriveBookView extends StatelessWidget {
  String bookViewLink;

  DriveBookView({required this.bookViewLink});

  @override
  Widget build(BuildContext context) {
    return SfPdfViewer.network(

        // kViewDriveContentUrl+bookViewId,
        bookViewLink);
  }
}
