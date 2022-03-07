import 'package:al_ashraf/screens/azkar_slawat.dart';
import 'package:al_ashraf/screens/downloads.dart';
import 'package:al_ashraf/screens/hadra_audio.dart';
import 'package:al_ashraf/screens/images_screen.dart';
import 'package:al_ashraf/screens/mobile_ringtones_screen.dart';
import 'package:al_ashraf/screens/more_screen.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

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

import 'models/audio_components.dart';
import 'models/post.dart';
import 'models/notification.dart';
import 'models/app_rating.dart';
import 'models/auto_update.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';



void main(){
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotification.initialize();
  FlutterDownloader.initialize();
  Hive.initFlutter();
  Hive.registerAdapter(PostAdapter());
  AppRating().checkRating();
  AutoUpdate().checkForNewUpdate();
  GlobalAudioPlayer.initializeBackGroundAudio();
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
        'images': (context)=>ImagesScreen(),
        'hadra_audio':(context)=>HadraAudioScreen(),
        'downloads': (context) => DownloadsScreen(),
        'azkar&slwat': (context)=>AzkarAndSalwat(),
        'mobile_ringtones':(context)=>MobileRingtonesScreen(),
        'more':(context)=>MoreScreen(),
      },
    );
  }
}
