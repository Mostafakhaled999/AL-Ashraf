import 'dart:io';

import 'package:al_ashraf/widgets/drive_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filesystem_picker/filesystem_picker.dart';

class DownloadsScreen extends StatelessWidget {
  String folderName;
  String folderPath;

  DownloadsScreen(
      {this.folderName = 'أحب محمدا',
      this.folderPath = '/storage/emulated/0/Download/أحب محمدا'});

  List<FileSystemEntity> _getFiles(String folderPath) {
    try {
      List<FileSystemEntity> files = Directory(folderPath).listSync();
      return files;
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Builder(
        builder: (context) {
          var downloadFiles = _getFiles(folderPath);
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
            return Center(
                child: Text(
              'لا يوجد ملفات محملة',
              style: TextStyle(fontSize: 30),
            ));
          }
        },
      ),
    ));
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
                    child: ListTile(
                      leading: Icon(
                        Icons.file_present,
                        size: 45,
                      ),
                      subtitle: Text(
                          (files[index].statSync().size / (1024 * 1024))
                                  .ceil()
                                  .toString() +
                              'mb'),
                      title: Text(files[index]
                          .path
                          .replaceAll(files[index].parent.path + '/', '')),
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
