import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class Instructions{
  String instructionText;
  String instructionKey;
  Instructions({required this.instructionKey,required this.instructionText});

  void dontShowPdfInstructions()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(instructionKey, true);
  }
  void checkForInstructions()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var contains = prefs.containsKey(instructionKey);
    if(!contains){
      showDialog(context: Get.context!, builder: (context) => CustomWidgets.customAlertDialog( instructionText, dontShowPdfInstructions),);
    }
  }
}