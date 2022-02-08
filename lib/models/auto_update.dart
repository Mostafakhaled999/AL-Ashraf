import 'dart:io';

import 'package:in_app_update/in_app_update.dart';
import 'package:new_version/new_version.dart';
import 'package:get/get.dart';


class AutoUpdate{

  static Future checkForNewUpdate()async{
    if(Platform.isAndroid){
      var updateInfo =  await InAppUpdate.checkForUpdate();
      if(updateInfo.updateAvailability == UpdateAvailability.updateAvailable){
        await InAppUpdate.startFlexibleUpdate();
        await InAppUpdate.completeFlexibleUpdate();
      }
    }else{
        final newVersion = NewVersion(
          iOSId: 'com.alabd.alashraf'
        );
        newVersion.showAlertIfNecessary(context: Get.context!);
    }
  }
}