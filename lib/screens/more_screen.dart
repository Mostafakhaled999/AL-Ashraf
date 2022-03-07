import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:al_ashraf/widgets/cards.dart';
import 'package:al_ashraf/constants/constants.dart';
import 'package:lottie/lottie.dart';

class MoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomWidgets.customAppBar('المزيد', appBarColor: Colors.green),
        body: CustomScrollView(
          slivers: [
            CardGridList(
              gridCardNames: kMoreHomeScreenCardNames,
              gridCardImages: (index) => Lottie.asset(
                  kMoreAnimatedHomeImgsPath[index],
                  fit: BoxFit.cover),
              onPress: (index) => Navigator.pushNamed(
                  context, kMoreHomeScreenRouteNames[index]),
            ),
          ],
        ));
  }
}
