
import 'screens/ahadeth_screen.dart';
import 'screens/diwan_books_screen.dart';
import 'screens/favourite_posts_screen.dart';
import 'screens/hadra_book_screen.dart';
import 'screens/home_screen.dart';
import 'screens/inshad_screen.dart';
import 'screens/nathr_books_screen.dart';
import 'screens/posts_screen.dart';
import 'screens/radio_screen.dart';
import 'screens/who_are_we_screen.dart';
import 'screens/contact_us_screen.dart';

import 'models/post.dart';
import 'models/notification.dart';
import 'models/app_rating.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotification.initialize();
  Hive.initFlutter();
  Hive.registerAdapter(PostAdapter());
  AppRating().checkRating();
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
        'home': (context) => HomeScreen(),
        'posts': (context) => PostsScreen(),
        'who_are_we': (context) => WhoAreWeScreen(),
        'contact_us': (context) => ContactUsScreen(),
        'ahadeth': (context) => AhadethScreen(),
        'inshad': (context) => InshadScreen(),
        'radio': (context) => RadioScreen(),
        'hadra_book': (context) => HadraBookScreen(),
        'diwans': (context) => DiwanBooksScreen(),
        'nathr_books': (context) => NathrBooksScreen(),
        'posts': (context) => PostsScreen(),
        'favourite_posts': (context) => FavouritePostsScreen(),
      },
    );
  }
}
