import 'package:al_ashraf/models/url_launcher.dart';
import 'package:al_ashraf/widgets/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/widgets/card_grid_list.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';

class WhoAreWeScreen extends StatelessWidget {
  const WhoAreWeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: CustomWidgets.customAppBar('من نحن'),
        body: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              CustomCircularImage(kWhoAreWeScrenImgPath),
              Padding(
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
              //SliverList(delegate: delegate)
            ])),
            CardGridList(
              gridCardNames: kWebsitesNames,
              cardNameDirection: TextDirection.ltr,
              cardNameMaxLines: 2,
              cardNameFontSize: 20,
              gridCardImages: (index)=>
                  Image(
                      image: AssetImage(kWebsitesImgsPath[index])),
              onPress:(index)=> UrlLauncher(kWebsitesURLs[index]),
            )
          ],
        ),
      ),
    );
  }
}
