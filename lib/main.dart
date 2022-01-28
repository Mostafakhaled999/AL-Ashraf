import 'package:al_ashraf/models/post.dart';
import 'package:al_ashraf/screens/ahadeth_screen.dart';
import 'package:al_ashraf/screens/diwan_books_screen.dart';
import 'package:al_ashraf/screens/favourite_posts_screen.dart';
import 'package:al_ashraf/screens/hadra_book_screen.dart';
import 'package:al_ashraf/screens/home_screen.dart';
import 'package:al_ashraf/screens/inshad_screen.dart';
import 'package:al_ashraf/screens/nathr_books_screen.dart';
import 'package:al_ashraf/screens/posts_screen.dart';
import 'package:al_ashraf/screens/radio_screen.dart';
import 'package:al_ashraf/screens/who_are_we_screen.dart';
import 'package:flutter/material.dart';
import 'package:al_ashraf/models/notification.dart';
import 'package:get/get.dart';
import 'screens/who_are_we_screen.dart';
import 'screens/contact_us_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotification.initialize();
  Hive.initFlutter();
  Hive.registerAdapter(PostAdapter());
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
        'favourite_posts': (context) => FavouritePostsScreen()
      },
    );
  }
}
