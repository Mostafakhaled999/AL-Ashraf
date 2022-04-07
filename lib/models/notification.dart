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

  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static Future initialize() async {
    await Firebase.initializeApp();

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    if(Platform.isIOS){


      await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    await _subscribeToTopic();

    await _startNotificationListners();
  }

  static Future<void> _subscribeToTopic() async {
    final pref = await SharedPreferences.getInstance();
    DateTime currentDate = DateTime.now();
    if (!pref.containsKey('lastNotificationReceivedDate')) {
      await messaging
          .subscribeToTopic('HobAlNabi')
          .whenComplete(() {
            pref.setString('lastNotificationReceivedDate', currentDate.toIso8601String());
      });
    }else{
      final lastNotificationReceivedDate = DateTime.parse(pref.getString('lastNotificationReceivedDate')!);
      final diff = currentDate.difference(lastNotificationReceivedDate).inDays;
      if(diff >= 2){
        await messaging
            .subscribeToTopic('HobAlNabi')
            .whenComplete(() {
          pref.setString('lastNotificationReceivedDate', currentDate.toIso8601String());
        });
      }
    }
  }

  static Future _startNotificationListners() async {
    final pref = await SharedPreferences.getInstance();
    DateTime currentDate = DateTime.now();
    //FirebaseMessaging.onBackgroundMessage(_messageHandler);
    messaging.getInitialMessage().then((message) {
      if (message != null) {
        pref.setString('lastNotificationReceivedDate', currentDate.toIso8601String());
        Get.to(() => PostsScreen(
              url: message.data['url'] ,
            ));
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      displayLocalNotification(
          title: message.notification!.title.toString() ,
          body: message.notification!.body.toString());
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      pref.setString('lastNotificationReceivedDate', currentDate.toIso8601String());
      //print('notification URL: ' + message.data['url']);
      Get.to(() => PostsScreen(
            url: message.data['url'],
          ));
    });
  }

  static void _onSelectLocalNotification(String? payload) async {
    Get.to(PostsScreen());
  }

  static Future<void> _initializeLocalNotification(
      Function onSelectLocalNotification) async {
    final InitializationSettings initializationSettings;

    if (Platform.isAndroid) {
      final AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@drawable/ic_action_name');

      initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );
    } else {
      final IOSInitializationSettings initializationSettingsIOS =
          IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );
      initializationSettings = InitializationSettings(
        iOS: initializationSettingsIOS,
      );
    }
    await _localNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) => onSelectLocalNotification(payload));
  }

  static void displayLocalNotification(
      {required String title,
      required String body,
      Function onSelectLocalNotification = _onSelectLocalNotification}) async {
    await _initializeLocalNotification(onSelectLocalNotification);
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'HobAlNabi', // id
      'Hob Al Nabi', // title
      // description
      importance: Importance.max,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    var platformChannelSpecifics = new NotificationDetails(
        android: AndroidNotificationDetails('HobAlNabi', 'Hob Al Nabi',
            importance: Importance.max, priority: Priority.high,),
        iOS: IOSNotificationDetails());

    await _localNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
