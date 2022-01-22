import 'package:al_ashraf/models/url_launcher.dart';
import 'package:al_ashraf/widgets/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/widgets/cards.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardListScreen(
      title: ' تواصل معنا',
      cardImagesPath: kContactsImgsPath,
      cardNames: kContactNames,
      cardUrls: kContactURLs,
      screenImagePath: kContactUsScreenImgPath,
      widget: SizedBox(height: 10,),
    );
  }
}


