import 'dart:io';

import 'package:al_ashraf/widgets/drive_widgets.dart';
import 'package:al_ashraf/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class DownloadsScreen extends StatelessWidget {
  String folderName;
  String? folderPath;

  DownloadsScreen(
      {this.folderName = 'أحب محمدا',
      this.folderPath });
//= '/storage/emulated/0/Download/أحب محمدا'
  Future<List<FileSystemEntity>> _getFiles(String? folderPath) async {
    if(folderPath == null){
     folderPath = Platform.isAndroid?'/storage/emulated/0/Download': (await getApplicationDocumentsDirectory()).path;
     folderPath += '/أحب محمدا';
     //print(folderPath);
    }
    try {
      List<FileSystemEntity> files = Directory(folderPath).listSync();
      return files;
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: FutureBuilder(
          future: _getFiles(folderPath),
          builder: (context, AsyncSnapshot<List<FileSystemEntity>> snapshot) {
            if (snapshot.hasData) {
              var downloadFiles = snapshot.data!;
              if (downloadFiles.isNotEmpty) {
                if (downloadFiles.first.statSync().type ==
                    FileSystemEntityType.directory) {
                  return DownloadFoldersScreen(
                      folders: downloadFiles, folderName: folderName);
                } else {
                  return DownloadsContentView(
                      files: downloadFiles, folderName: folderName);
                }
              } else {
                return NoDownloadsFoundScreen();
              }
            }else{
              return LoadingWidget();
            }
          }),
    ));
  }
}

class NoDownloadsFoundScreen extends StatelessWidget {
  const NoDownloadsFoundScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
            child: Text(
          'لا يوجد ملفات محملة',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        )),
        Positioned(
          height: 50,
          width: 50,
          top: 10,
          left: 10,
          child: Card(
              elevation: 5,
              color: Colors.lightGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: IconButton(
                icon: Icon(
                  Icons.adaptive.arrow_back,
                  size: 25,
                  color: Colors.white,
                ),
                //color: Colors.green,
                onPressed: () {
                  Navigator.pop(context);
                },
              )),
        ),
      ],
    );
  }
}

class DownloadFoldersScreen extends StatelessWidget {
  String folderName;
  List<FileSystemEntity> folders;

  DownloadFoldersScreen({required this.folders, required this.folderName});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate([
          Padding(
            padding: EdgeInsets.all(12),
            child: NewAppBar(screenTitle: folderName),
          ),
        ])),
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
              (context, index) => GestureDetector(
                    child: FolderGridCard(
                        folderName: folders[index]
                            .path
                            .replaceAll(folders[index].parent.path + '/', '')),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DownloadsScreen(
                            folderName: folderName +
                                ' / ' +
                                folders[index].path.replaceAll(
                                    folders[index].parent.path + '/', ''),
                            folderPath: folders[index].path,
                          ),
                        ),
                      );
                    },
                  ),
              childCount: folders.length),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
        )
      ],
    );
  }
}

class DownloadsContentView extends StatelessWidget {
  String folderName;
  List<FileSystemEntity> files;

  DownloadsContentView({required this.files, required this.folderName});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate([
          Padding(
            padding: EdgeInsets.all(12),
            child: NewAppBar(screenTitle: folderName),
          ),
        ])),
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, index) => GestureDetector(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: ListTile(
                        leading: Icon(
                          Icons.file_present,
                          size: 45,
                        ),
                        subtitle: Text(
                          '${(files[index].statSync().size / (1024 * 1024)).ceil()}'
                          'mb',
                        ),
                        title: Text(
                          files[index]
                              .path
                              .replaceAll(files[index].parent.path + '/', ''),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    onTap: () {
                      OpenFile.open(files[index].path);
                    },
                  ),
              childCount: files.length),
        )
      ],
    );
  }
}
