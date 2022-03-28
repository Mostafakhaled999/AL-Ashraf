import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:al_ashraf/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:share_plus/share_plus.dart';

import 'downloads.dart';

class GoogleDrive {
  String name;
  String id;
  String type;
  String? thumbnail;
  String? mainLink;
  String? backupLink;
  int? size;
  bool root;
  GoogleDrive? parent;

  GoogleDrive(
      {required this.name,
      required this.id,
      required this.type,
      required this.root,
      this.parent,
      this.thumbnail,
      this.size,
      this.mainLink,
      this.backupLink});

  void share() {
    Share.share('https://drive.google.com/file/d/${id}/view');
  }

  Future download() async {
    DownloadModel(driveFile: this).download();
  }
}

class DriveContent {
  List<GoogleDrive> content = [];
  String contentType = '';

  get contentLength {
    return content.length;
  }

  Future<bool> getDriveContent(GoogleDrive driveFolder) async {
    String requestUrl =
        //'https://www.googleapis.com/drive/v3/files?orderBy=name&q=%27${driveFolder.id}%27+in+parents&fields=files&key=AIzaSyAeY-DbnUnHHKIApKT5DFZ7vKVfjOmMn14';
        'https://www.googleapis.com/drive/v3/files?' //drive.list
        'orderBy=name&' //order content by name
        'q=%27${driveFolder.id}%27%20in%20parents&' //get a specific id
        'fields=files(name%2Cid%2CmimeType%2CthumbnailLink%2CwebContentLink%2CquotaBytesUsed)&' //get certain fields
        'key=AIzaSyAeY-DbnUnHHKIApKT5DFZ7vKVfjOmMn14'; //api key
    var response = await http.get(Uri.parse(requestUrl));
    if (response.statusCode == 200) {
      _decodeContent(response, driveFolder);
      return true;
    } else {
      Get.showSnackbar(
          CustomWidgets.customSnackBar('حدث خطأ حاول فى وقت لاحق'));
      return Future.error('حدث خطأ حاول فى وقت لاحق');
    }
  }

  _decodeContent(dynamic response, GoogleDrive driveFolder) {
    var decodedResponse = jsonDecode(response.body)['files'];
    for (var data in decodedResponse) {
      GoogleDrive driveElement = GoogleDrive(
          name: data['name'],
          id: data['id'],
          type: data['mimeType'],
          thumbnail: data['thumbnailLink'] ?? '',
          mainLink: data['webContentLink'] ?? '',
          size: int.parse(data['quotaBytesUsed'].toString())
              ,
          backupLink: kViewDriveContentUrl + data['id'],
          root: false,
          parent: driveFolder);
      contentType = data['mimeType'];
      content.add(driveElement);
    }
  }
}
