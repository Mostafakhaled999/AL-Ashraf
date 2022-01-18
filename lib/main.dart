import 'package:al_ashraf/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:al_ashraf/models/notification.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotification.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'أحب محمدا',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.white,
        //primarySwatch: Colors.white,
      ),
      home: HomeScreen(),
      routes: {
        'home': (context)=> HomeScreen(),

      },

    );
  }
}

