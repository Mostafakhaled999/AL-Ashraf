import 'package:flutter/material.dart';
import 'dart:io' show Platform;

const Color kCardColor = Color(0xFFF1F2F6);

const String kHomeScreenImgPath =
    'assets/images/main_screen_image/main_screen_image.jpg';
const String kWhoAreWeScrenImgPath =
    'assets/images/who_are_we_screen_image/who_are_we_screen_image.JPG';
const String kContactUsScreenImgPath =
    'assets/images/contact_us_screen_image/contact_us_screen_image.JPG';
const String kAlkobbaBGImgPath =
    'assets/images/back_ground_image/back_ground.jpg';
const String kRadioScreenImgPath =
    'assets/images/radio_screen_image/radio_screen_image.png';
const String kBackGroundSrchBarImgPath =
    'assets/images/books_screen/background_search.png';
const String kHadraBookCoverPath =
    'assets/images/books_screen/book_covers/hadra_cover.jpg';

const kFolderDriveType = "application/vnd.google-apps.folder";
const kAudioFileDriveType = 'audio';

const kAhadethDriveFolderId = '0B40BecadRW2eVkhncEpYeWtjeUk';
const kInshadDriveFolderId = '0B40BecadRW2eaVVzNUJCbnk1RDA';
const kImagesDriveFolderId = '16AZNt-viGdSNoCxkSLma3OgU6wwXhJK7';
const kHadraAudioDriveFolderId = '0B40BecadRW2edERFbTFBcnZJR2c';

const kViewDriveContentUrl = 'https://drive.google.com/uc?export=view&id=';

const kMainPostUrl = 'https://alashraf-almahdia.net/';

const kDiwanEpubWithTashkilPath =
    'assets/books/epub/diwan_epub_with_tashkil.epub';
const kDiwanEpubWithOutTashkilPath =
    'assets/books/epub/diwan_epub_without_tashkil.epub';

const List<String> kHomeScreenCardNames = [
  "المقالات",
  "المقالات المفضلة",
  "الدواوين",
  "كتب النثر",
  "الإذاعة",
  "كتاب الحضرة",
  "صوت الحضرة",
  "الأحاديث",
  "الإنشاد",
  "الصور",
  "من نحن",
  "اتصل بنا",
];
const List<String> kScreenRouteNames = [
  'posts',
  'favourite_posts',
  'diwans',
  'nathr_books',
  'radio',
  'hadra_book',
  'hadra_audio',
  'ahadeth',
  'inshad',
  'images',
  'who_are_we',
  'contact_us',
];

const List<String> kAnimatedHomeImgsPath = [
  "assets/lottie_gifs/home_screen/posts.json",
  "assets/lottie_gifs/home_screen/favourite_posts.json",
  "assets/lottie_gifs/home_screen/diwans.json",
  "assets/lottie_gifs/home_screen/nathr_books.json",
  "assets/lottie_gifs/home_screen/radio.json",
  "assets/lottie_gifs/home_screen/hadra_book.json",
  "assets/lottie_gifs/home_screen/hadra_audio.json",
  "assets/lottie_gifs/home_screen/ahadeth.json",
  "assets/lottie_gifs/home_screen/inshad.json",
  "assets/lottie_gifs/home_screen/images.json",
  "assets/lottie_gifs/home_screen/who_are_we.json",
  "assets/lottie_gifs/home_screen/contact_us.json",
];
List<String> kWebsitesURLs = [
  'http://www.alabd.com/',
  'http://alashraf-almahdia.com/',
  'https://alashraf-almahdia.net/',
  'https://attention.fm/',
  'https://twitter.com/salah_alkousy',
  'https://www.youtube.com/channel/UCBf9qI7gYSgWyWA39c_jRCg',
];
List<String> kWebsitesNames = [
  'ALABD.COM',
  'ALASHRAF-ALMAHDIA.COM',
  'ALASHRAF-ALMAHDIA.NET',
  'ATTENTION.FM',
  'Twitter',
  'YouTube',
];
List<String> kWebsitesImgsPath = [
  'assets/images/who_are_we_screen_image/world-wide-web64.png',
  'assets/images/who_are_we_screen_image/world-wide-web64.png',
  'assets/images/who_are_we_screen_image/world-wide-web64.png',
  'assets/images/who_are_we_screen_image/world-wide-web64.png',
  'assets/images/who_are_we_screen_image/twitter64.png',
  'assets/images/who_are_we_screen_image/youtube64.png',
];
List<String> kContactURLs = [
  'whatsapp://send?phone=+201117841111',
  'mailto:alashrafapp@gmail.com',
];
List<String> kContactNames = ['Whatsapp', 'Gmail'];
List<String> kContactsImgsPath = [
  'assets/images/contact_us_screen_image/whatsapp64.png',
  'assets/images/contact_us_screen_image/gmail64.png'
];
List<String> kRadioChannelsName = ['القرآن', 'حب النبي'];
List<String> kRadioChannelsFreq = [
  'http://185.80.220.12:8048/stream',
  'https://s1.reliastream.com/proxy/oelgendy?mp=/stream'
];

const String kHadraBookPath =
    'assets/books/pdf/hadra/الحضرة كاملة الطبعة 29 بدون هوامش.pdf';
List<String> kDiwanBookTitles = [
  "ديوان الأسير",
  "ديوان العتيق",
  "ديوان الطليق",
  "ديوان الغريق",
  "ديوان الرفيق",
  "ديوان الحقيق",
  "ديوان العقيق",
  "ديوان الوثيق",
  "ديوان الرحيق",
  "ديوان البريق",
  "ديوان الفية محمد",
  "ديوان محمد الإمام المبين",
  "ديوان العشيق",
  "ديوان الرشيق",
  "ديوان الرقيق",
  "ديوان المفيق",
  "ديوان العريق",
  "ديوان الفريق",
  "ديوان الشفيق",
  "ديوان الوفيق",
  "ديوان فى حب أشرف البرية"
];

List<String> kDiwanPartNames = [
  "الجزء الأول",
  "الجزء الثانى",
  "الجزء الثالث",
  "الجزء الرابع",
  "الجزء الخامس",
  "الجزء السادس",
  "الجزء السابع",
  "الجزء الثامن",
  "الجزء التاسع",
  "الجزء العاشر",
  "الجزء الحادى عشر",
  "الجزء الثانى عشر",
  "الجزء الثالث عشر",
  "الجزء الرابع عشر",
  "الجزء الخامس عشر",
  "الجزء السادس عشر",
  "الجزء السابع عشر",
  "الجزء الثامن عشر",
  "الجزء التاسع عشر",
  "الجزء العشرون",
  "الجزء الواحد والعشرون"
];
//assets/books/pdf/nathr/ihsanAll.pdf
List<String> kDiwanPdfContentPaths = [
  'assets/books/pdf/diwan/ديوان الأسير1.pdf',
  'assets/books/pdf/diwan/ديوان العتيق2.pdf',
  'assets/books/pdf/diwan/ديوان الطليق3.pdf',
  'assets/books/pdf/diwan/ديوان الغريق4.pdf',
  'assets/books/pdf/diwan/ديوان الرفيق5.pdf',
  'assets/books/pdf/diwan/ديوان الحقيق6.pdf',
  'assets/books/pdf/diwan/ديوان العقيق7.pdf',
  'assets/books/pdf/diwan/ديوان الوثيق8.pdf',
  'assets/books/pdf/diwan/ديوان الرحيق9.pdf',
  'assets/books/pdf/diwan/ديوان البريق10.pdf',
  'assets/books/pdf/diwan/ديوان الفية محمد صلى الله عليه وسلم11.pdf',
  'assets/books/pdf/diwan/ديوان محمد الإمام المبين12.pdf',
  'assets/books/pdf/diwan/ديوان العشيق13.pdf',
  'assets/books/pdf/diwan/ديوان الرشيق14.pdf',
  'assets/books/pdf/diwan/ديوان الرقيق15.pdf',
  'assets/books/pdf/diwan/ديوان المفيق16.pdf',
  'assets/books/pdf/diwan/ديوان العريق17.pdf',
  'assets/books/pdf/diwan/ديوان الفريق18.pdf',
  'assets/books/pdf/diwan/ديوان الشفيق19.pdf',
  'assets/books/pdf/diwan/ديوان الوفيق20.pdf',
  'assets/books/pdf/diwan/ديوان فى حب أشرف البرية.pdf'
];
//assets/images/books_screen/diwan_cover/alaareq.jpg
List<String> kDiwanCoverPaths = [
  "assets/images/books_screen/diwan_cover/alaseer.jpg",
  "assets/images/books_screen/diwan_cover/alateek.jpg",
  "assets/images/books_screen/diwan_cover/altaleek.jpg",
  "assets/images/books_screen/diwan_cover/alghareek.jpg",
  "assets/images/books_screen/diwan_cover/alrafeek.jpg",
  "assets/images/books_screen/diwan_cover/alhakeek.jpg",
  "assets/images/books_screen/diwan_cover/alakeek.jpg",
  "assets/images/books_screen/diwan_cover/alwatheek.jpg",
  "assets/images/books_screen/diwan_cover/alraheek.jpg",
  "assets/images/books_screen/diwan_cover/albareek.jpg",
  "assets/images/books_screen/diwan_cover/alfeyya.jpg",
  "assets/images/books_screen/diwan_cover/alemam.jpg",
  "assets/images/books_screen/diwan_cover/alasheek.jpg",
  "assets/images/books_screen/diwan_cover/dewan-alrasheq.jpg",
  "assets/images/books_screen/diwan_cover/alrarkek.jpg",
  "assets/images/books_screen/diwan_cover/elmafeeq.jpg",
  "assets/images/books_screen/diwan_cover/alaareq.jpg",
  "assets/images/books_screen/diwan_cover/alfareek.jpg",
  "assets/images/books_screen/diwan_cover/alshafeeq.jpg",
  "assets/images/books_screen/diwan_cover/alwafeek.jpg",
  'assets/images/books_screen/diwan_cover/ashrf-albarya.jpg'
];
List<String> kNathrPdfContentPaths = [
  'assets/books/pdf/nathr/islamAll.pdf',
  'assets/books/pdf/nathr/imanAll.pdf',
  'assets/books/pdf/nathr/osool.pdf',
  'assets/books/pdf/nathr/ihsanAll.pdf',
  'assets/books/pdf/nathr/nabiAll.pdf',
  'assets/books/pdf/nathr/mishkaa.pdf',
];

List<String> kNathrBooksCoverPaths = [
  'assets/images/books_screen/nathr_books_covers/islam.jpg',
  'assets/images/books_screen/nathr_books_covers/iman.jpg',
  'assets/images/books_screen/nathr_books_covers/osool.jpg',
  'assets/images/books_screen/nathr_books_covers/ihsan.jpg',
  'assets/images/books_screen/nathr_books_covers/nabeena.jpg',
  'assets/images/books_screen/nathr_books_covers/mishkaa.jpg',
];
List<String> kNathrBookTitles = [
  'أركان الإِسلام',
  'قواعد الإيمان',
  'مقدمة أصول الوصول',
  'أنوار الإحسان',
  'محمد نبى الرحمة',
  'محمد مشكاة الأنوار',
];
List<String> kNathrBooksPartNames = [
  "الجزء الأول",
  "الجزء الثانى",
  "الجزء الثالث",
  "الجزء الرابع",
  "الجزء الخامس",
  "الجزء السادس",
];
