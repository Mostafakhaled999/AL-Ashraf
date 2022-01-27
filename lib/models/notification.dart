import 'package:al_ashraf/screens/posts_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'dart:io';

class LocalNotification {

  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static  void initialize()async{
    await Firebase.initializeApp();
    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await _subscribeToTopic();

    _startNotificationListners();
  }

  static Future<void> _subscribeToTopic() async{
    var pref = await SharedPreferences.getInstance();
    if(!pref.containsKey('subscribedToHobAlNabi'))
    {
      await FirebaseMessaging.instance.subscribeToTopic('HobAlNabi').whenComplete((){
        print('successfully subscribed');
        pref.setBool('subscribedToHobAlNabi', true);
      });
    }
  }

  static void _startNotificationListners() async{
    //FirebaseMessaging.onBackgroundMessage(_messageHandler);
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message != null){
        Get.to(PostsScreen());}
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _displayLocalNotification(title: message.notification!.title.toString(),
          body: message.notification!.body.toString());
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("Message recieved from background");
      Get.to(PostsScreen());
    });
  }

  static void _onSelectLocalNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
    Get.to(PostsScreen());
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
         onSelectNotification: _onSelectLocalNotification);
   }
  static void _displayLocalNotification({required String title, required String body}) async {

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
