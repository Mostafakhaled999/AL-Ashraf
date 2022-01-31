import 'package:flutter/material.dart';
import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/widgets/cards.dart';


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


