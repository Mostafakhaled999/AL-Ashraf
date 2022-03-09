import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/models/google_drive.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadModel {
  GoogleDrive driveFile;

  DownloadModel({required this.driveFile});

  Future download() async {
    try {
      if (await _requestPermission(Permission.storage)) {
        String? savePath;
        final url =
            'https://www.googleapis.com/drive/v3/files/${driveFile.id}?alt=media&key=AIzaSyAeY-DbnUnHHKIApKT5DFZ7vKVfjOmMn14';
        final request = Request('GET', Uri.parse(url));
        final StreamedResponse response = await Client().send(request);
        var bytes = [].obs;
        List<int> bytes2 = [];
        final snackBar = GetSnackBar(
          showProgressIndicator: true,
          progressIndicatorBackgroundColor: Colors.green,
          titleText: Obx(() => Text(
                'يتم تحميل الملف ...'
                ' ${((bytes.length / driveFile.size!) * 100).ceil()}%',
                textDirection: TextDirection.rtl,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
          messageText: Text(
            '${driveFile.name}',
            textDirection: TextDirection.rtl,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          borderRadius: 20,
          snackStyle: SnackStyle.FLOATING,
          margin: EdgeInsets.all(10),
          snackPosition: SnackPosition.BOTTOM,
          mainButton: Obx(() => bytes.length != driveFile.size!
              ? CircularProgressIndicator(
                  color: Colors.green,
                  value: (bytes.length / driveFile.size!),
                )
              : TextButton(
                  onPressed: () {
                    Get.closeAllSnackbars();
                    OpenFile.open(savePath);
                  },
                  child: Text('فتح'))),
          isDismissible: true,
        );
        Get.showSnackbar(snackBar);

        response.stream.listen(
          (List<int> newBytes) async {
            bytes.addAll(newBytes);
            bytes2.addAll(newBytes);
          },
          onDone: () async {
            savePath = await _saveDownloadedFile(bytes2);
          },
          onError: (e) {
            print(e);
            Get.showSnackbar(CustomWidgets.customSnackBar('حدث خطأ'));
          },
          cancelOnError: true,
        );
      } else {
        throw new Exception('Storage Permission required');
      }
    } catch (e) {
      print(e);
      Get.showSnackbar(
          CustomWidgets.customSnackBar('حدث خطأ حاول فى وقت لاحق'));
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var permStatus = await permission.request();
      if (permStatus == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  String _getDrivePath(GoogleDrive parent) {
    if (!parent.root)
      return _getDrivePath(parent.parent!) + '/' + parent.name;
    else
      return parent.name;
  }

  Future<String> _getIOSAppDirectoryPath() async {
    String path = (await getApplicationDocumentsDirectory()).path;
    return path;
  }

  Future<String> _getFullDownloadedFilePath() async {
    String downlaodDirectoryPath;
    if (Platform.isAndroid) {
      downlaodDirectoryPath = kAndroidDownloadFolderPath;
    } else {
      downlaodDirectoryPath = await _getIOSAppDirectoryPath();
    }

    final appRootDirectoryPath = downlaodDirectoryPath + '/' + 'أحب محمدا';
    final driveFilePath = _getDrivePath(driveFile.parent!);
    final fullDownloadedFilePath = appRootDirectoryPath + '/' + driveFilePath;
    return fullDownloadedFilePath;
  }

  Future<String> _saveDownloadedFile(List<int> downloadedData) async {
    final fullDownloadedFilePath = await _getFullDownloadedFilePath();
    File downloadedFile =
        await File(fullDownloadedFilePath + '/' + driveFile.name)
            .create(recursive: true);
    final savedFile = downloadedFile.openSync(mode: FileMode.write);
    savedFile.writeFromSync(downloadedData);
    await savedFile.close();
    return savedFile.path;
    //await OpenFile.open(downloadedFile.path);
  }
}
