import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CustomWidgets {
  static AppBar customAppBar(
    String titleText, {
    bool centerTitle = true,
    Color titleTextColor = Colors.white,
    double fontSize = 30,
    double elevation = 1,
    Color appBarColor = Colors.transparent,
    Color iconColor = Colors.white,
  }) {
    return AppBar(
      elevation: elevation,
      backgroundColor: appBarColor,
      centerTitle: centerTitle,
      title: Text(
        titleText,
        textDirection: TextDirection.rtl,
      ),
      titleTextStyle: TextStyle(
          color: titleTextColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold),
      leading: IconButton(
        icon: Icon(
          Icons.adaptive.arrow_back,
          size: 30,
          color: iconColor,
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
