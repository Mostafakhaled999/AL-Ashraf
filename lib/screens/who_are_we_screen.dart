import 'package:al_ashraf/models/url_launcher.dart';
import 'package:al_ashraf/widgets/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/widgets/cards.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';

class WhoAreWeScreen extends StatelessWidget {
  const WhoAreWeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      CardListScreen(
        title: 'من نحن',
        cardImagesPath: kWebsitesImgsPath,
        cardNames: kWebsitesNames,
        cardUrls: kWebsitesURLs,
        screenImagePath: kWhoAreWeScrenImgPath,
        widget: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'فى حب المصطفي صلي اللـه عليه وسلم'
                ' هذا الموقع و التطبيق يهدف إلى'
                ' نشر تراث عبد اللـه // صلاح الدين القوصي'
                ' رضي اللـه عنه و أرضاه'
                ' المقروء و المسموع و المرئي'
                ' مواقعنا:',
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      );
  }
}
