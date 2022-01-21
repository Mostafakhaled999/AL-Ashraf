import 'package:flutter/material.dart';
import 'package:al_ashraf/models/google_drive.dart';
import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/widgets/loading_widget.dart';
import 'package:al_ashraf/widgets/folder_grid_list.dart';
import 'package:get/get.dart';
import 'package:al_ashraf/screens/audio_list_screen.dart';

class AhadethScreen extends StatefulWidget {
  const AhadethScreen({Key? key}) : super(key: key);

  @override
  _AhadethScreenState createState() => _AhadethScreenState();
}

class _AhadethScreenState extends State<AhadethScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: GoogleDrive().getDriveContent(kAhadethRootFolderId,kFolderDriveType),
          builder: (context, AsyncSnapshot<DriveContent?> snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.adaptive.arrow_back),
                            iconSize: 40,
                            color: Colors.black,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Text(
                            "الأحاديث",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 45,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ])),
                  FolderGridList(
                    folderNames: snapshot.data!.contentNames,
                    folderIds: snapshot.data!.contentIds,
                    onPress: (index) =>
                        Get.to(() => AudioListScreen(folderId:snapshot.data!.contentIds[index],folderName: snapshot.data!.contentNames[index],)),
                  )
                ],
              );
            } else {
              return LoadingWidget();
            }
          },
        ),
      ),
    );
  }
}
