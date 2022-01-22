import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';

class GoogleDrive {

   DriveContent _driveContent = DriveContent();

   Future<DriveContent> getDriveContent(String folderId,String contentType,bool sortByName) async {

    String requestUrl =
        'https://www.googleapis.com/drive/v3/files?${sortByName?'orderBy=name&':''}q=%27$folderId%27+in+parents&key=AIzaSyAeY-DbnUnHHKIApKT5DFZ7vKVfjOmMn14';
    var response = await http.get(Uri.parse(requestUrl));
    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body)['files'];

      for (var content in decodedResponse) {
        if (content['mimeType'].contains(contentType)) {
          var folderName = content['name'];
          var folderId = content['id'];
          _driveContent.contentNames.add(folderName);
          _driveContent.contentIds.add(folderId);
        }
      }
      return _driveContent;
    } else {
      Get.back();
      Get.showSnackbar(
          CustomWidgets.customSnackBar('حدث خطأ حاول فى وقت لاحق'));
      return Future.error('حدث خطأ حاول فى وقت لاحق');
    }
  }

}

class DriveContent{
  List<String> contentNames = [];
  List<String> contentIds = [];

}


