import 'package:al_ashraf/models/url_launcher.dart';
import 'package:al_ashraf/widgets/circular_image.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:al_ashraf/constants/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:lottie/lottie.dart';
import 'package:al_ashraf/models/app_rating.dart';
import 'dart:io' show Platform;
import 'package:share_plus/share_plus.dart';

class CardListScreen extends StatelessWidget {
  String title;
  String screenImagePath;
  Widget widget;
  List<String> cardImagesPath;
  List<String> cardUrls;
  List<String> cardNames;

  CardListScreen(
      {required this.title,
      required this.cardImagesPath,
      required this.cardNames,
      required this.widget,
      required this.cardUrls,
      required this.screenImagePath});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: false,
        appBar: CustomWidgets.customAppBar(title, appBarColor: Colors.green),
        body: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              CustomCircularImage(imagePath: screenImagePath),
              SizedBox(
                height: 10,
              ),
              widget
            ])),
            CardGridList(
              gridCardNames: cardNames,
              cardNameDirection: TextDirection.ltr,
              cardNameMaxLines: 2,
              cardNameFontSize: 20,
              gridCardImages: (index) =>
                  Image(image: AssetImage(cardImagesPath[index])),
              onPress: (index) => UrlLauncher(cardUrls[index]),
            )
          ],
        ),
      ),
    );
  }
}

class CardGridList extends StatelessWidget {
  List<String> gridCardNames;
  Function gridCardImages;
  Function onPress;
  double cardNameFontSize;
  FontWeight cardNameFontWeight;
  TextDirection cardNameDirection;
  int cardNameMaxLines;

  CardGridList({
    required this.gridCardNames,
    required this.gridCardImages,
    required this.onPress,
    this.cardNameFontSize = 30,
    this.cardNameFontWeight = FontWeight.bold,
    this.cardNameDirection = TextDirection.rtl,
    this.cardNameMaxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
          (context, index) => GridCard(
              gridCardImage: gridCardImages(index),
              gridCardWidget: ImageCardText(
                  gridCardName: gridCardNames[index],
                  cardNameMaxLines: cardNameMaxLines,
                  cardNameFontSize: cardNameFontSize,
                  cardNameFontWeight: cardNameFontWeight,
                  cardNameDirection: cardNameDirection),
              onPress: () => onPress(index)),
          childCount: gridCardNames.length),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}

class ImageCardText extends StatelessWidget {
  const ImageCardText({
    Key? key,
    required this.gridCardName,
    this.cardNameFontSize = 30,
    this.cardNameFontWeight = FontWeight.bold,
    this.cardNameDirection = TextDirection.rtl,
    this.cardNameMaxLines = 1,
  }) : super(key: key);

  final String gridCardName;
  final int cardNameMaxLines;
  final double cardNameFontSize;
  final FontWeight cardNameFontWeight;
  final TextDirection cardNameDirection;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: AutoSizeText(
          gridCardName,
          maxLines: cardNameMaxLines,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: cardNameFontSize,
            fontWeight: cardNameFontWeight,
          ),
          textDirection: cardNameDirection,
          softWrap: true,
          overflow: TextOverflow.clip,
        ));
  }
}

class GridCard extends StatelessWidget {
  const GridCard({
    Key? key,
    required this.gridCardImage,
    required this.gridCardWidget,
    required this.onPress,
    this.crossAxisAlignment = CrossAxisAlignment.center
  }) : super(key: key);

  final Widget gridCardImage;
  final Widget gridCardWidget;
  final Function onPress;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        elevation: 10,
        color: kCardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: gridCardImage,
            ),
           gridCardWidget
          ],
        ),
      ),
      onTap: () => onPress(),
    );
  }
}

class ExtraHomeScreenCards {
  static GridCard shareAppCard() {
    return GridCard(
        gridCardImage:
            Lottie.asset('assets/lottie_gifs/home_screen/share.json'),
        gridCardWidget: ImageCardText(gridCardName: 'شارك التطبيق'),
        onPress: () {
          if (Platform.isAndroid) {
            Share.share(
                'https://play.google.com/store/apps/details?id=com.alabd.alashraf');
          }else{
            //TODO: add apple store id for app share
          }
        });
  }

  static GridCard rateAppCard() {
    return GridCard(
        gridCardImage:
            Lottie.asset('assets/lottie_gifs/home_screen/rate_app.json'),
        gridCardWidget: ImageCardText(gridCardName: 'قيم التطبيق'),
        onPress: () {
          AppRating.rate();
        });
  }
}
