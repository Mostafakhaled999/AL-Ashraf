import 'dart:io';

import 'package:in_app_update/in_app_update.dart';
import 'package:new_version/new_version.dart';
import 'package:get/get.dart';

class AutoUpdate {
  Future checkForNewUpdate() async {
    if (Platform.isAndroid) {
      try {
        await _androidUpdate();
      } catch (e) {
        print("Android update Error: " + e.toString());
      }
    } else {
      try {
        await _iosUpdate();
      } catch (e) {
        print("Ios update Error: " + e.toString());
      }
    }
  }

  Future _androidUpdate() async {
    var updateInfo = await InAppUpdate.checkForUpdate();
    if (updateInfo != null &&
        updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      await InAppUpdate.startFlexibleUpdate();
      await InAppUpdate.completeFlexibleUpdate();
    }
  }

  Future _iosUpdate() async {
    final newVersion = NewVersion(iOSId: 'com.alabd.alashraf');
    await newVersion.showAlertIfNecessary(context: Get.context!);
  }
}
