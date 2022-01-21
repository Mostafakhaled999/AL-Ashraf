import 'package:al_ashraf/models/url_launcher.dart';
import 'package:al_ashraf/widgets/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/widgets/card_grid_list.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: CustomWidgets.customAppBar('تواصل معنا'),
        body: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              CustomCircularImage(kWhoAreWeScrenImgPath),
              SizedBox(
                height: 20,
              )
            ])),
            CardGridList(
              gridCardNames: kContactNames,
              cardNameDirection: TextDirection.ltr,
              cardNameMaxLines: 2,
              cardNameFontSize: 20,
              gridCardImages: (index) =>
                  Image(image: AssetImage(kContactImgsPath[index])),
              onPress: (index) => UrlLauncher(kContactURLs[index]),
            )
          ],
        ),
      ),
    );
  }
}
