import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CustomWidgets {
  static AppBar customAppBar(String titleText,{bool centerTitle = true,double fontSize = 30}) {
    return AppBar(
      elevation: 1,
      backgroundColor: Colors.transparent,
      centerTitle: centerTitle,
      title: Text(
        titleText,
        textDirection: TextDirection.rtl,
      ),
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.bold),
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
        isDismissible: true,
        borderRadius: 15,
        snackStyle: SnackStyle.FLOATING,
        margin: EdgeInsets.all(5),
        duration: Duration(seconds: 3),
        messageText: AutoSizeText(
          textContent,
          maxLines: 1,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}
