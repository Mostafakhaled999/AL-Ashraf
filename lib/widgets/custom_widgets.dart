import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CustomWidgets {
  static AppBar customAppBar(String titleText) {
    return AppBar(
      elevation: 1,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Text(
        titleText,
      ),
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
      leading: IconButton(
        icon: Icon(
          Icons.adaptive.arrow_back,
          size: 30,
        ),
        onPressed: () {
          Get.back();
        },
      ),
    );
  }

  static GetSnackBar customSnackBar(String textContent) {
    return GetSnackBar(
        titleText: AutoSizeText(
      textContent,
      maxLines: 1,
      textDirection: TextDirection.rtl,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ));
  }
}
