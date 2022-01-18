import 'package:al_ashraf/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'dart:io';

class LocalNotification {

  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> _subscribeToTopic() async{
    var pref = await SharedPreferences.getInstance();
    if(!pref.containsKey('subscribedToHobAlNabi'))
    {
      FirebaseMessaging.instance.subscribeToTopic('dev').whenComplete((){
        pref.setBool('subscribedToHobAlNabi', true);
      });
    }
  }
  static void _startNotificationListners() async{

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message != null)
        Get.to(() => HomeScreen());
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _displayNotification(title: message.notification!.title.toString(),
          body: message.notification!.body.toString());
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Get.to(() => HomeScreen());
    });
  }
   static  void initialize()async{

    await Firebase.initializeApp();
    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await _subscribeToTopic();

    _startNotificationListners();
  }
  static void _selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
    Get.to(() => HomeScreen());
  }
  static Future<void> _initializeLocalNotification() async{

    final InitializationSettings initializationSettings;

    if(Platform.isAndroid) {
        final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_action_name');

          initializationSettings =
        InitializationSettings(
          android:initializationSettingsAndroid,
        );
      }
    else {
        final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        );
         initializationSettings =
        InitializationSettings(
          iOS: initializationSettingsIOS,
        );
      }
     await _localNotificationsPlugin.initialize(
         initializationSettings,
         onSelectNotification: _selectNotification);
   }
  static void _displayNotification({required String title, required String body}) async {

    await _initializeLocalNotification();

    var platformChannelSpecifics = new NotificationDetails(
        android: AndroidNotificationDetails(
            'HobAlNabi', 'HOB AL NABI',
            importance: Importance.max, priority: Priority.high), iOS: IOSNotificationDetails());

    await _localNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

}
