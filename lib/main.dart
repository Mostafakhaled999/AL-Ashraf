import 'package:al_ashraf/screens/ahadeth_screen.dart';
import 'package:al_ashraf/screens/home_screen.dart';
import 'package:al_ashraf/screens/posts_screen.dart';
import 'package:al_ashraf/screens/who_are_we_screen.dart';
import 'package:flutter/material.dart';
import 'package:al_ashraf/models/notification.dart';
import 'package:get/get.dart';
import 'screens/who_are_we_screen.dart';
import 'screens/contact_us_screen.dart';

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
    return GetMaterialApp(
      title: 'أحب محمدا',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          },
        ),
        backgroundColor: Colors.white,
        //primarySwatch: Colors.white,
      ),
      home: HomeScreen(),
      routes: {
        'home': (context)=> HomeScreen(),
        'posts': (context)=> PostsScreen(),
        'who_are_we': (context)=> WhoAreWeScreen(),
        'contact_us': (context)=> ContactUsScreen(),
        'ahadeth':(context)=> AhadethScreen()
      },

    );
  }
}

