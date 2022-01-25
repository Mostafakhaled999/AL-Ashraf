import 'package:al_ashraf/models/url_launcher.dart';
import 'package:al_ashraf/widgets/circular_image.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:al_ashraf/constants/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:marquee/marquee.dart';


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
        extendBodyBehindAppBar: true,
        appBar: CustomWidgets.customAppBar(title),
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

  CardGridList(
      {required this.gridCardNames,
      required this.gridCardImages,
      required this.onPress,
      this.cardNameFontSize = 30,
      this.cardNameFontWeight = FontWeight.bold,
      this.cardNameDirection = TextDirection.rtl,
      this.cardNameMaxLines = 1});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
          (context, index) => ImageCard(
              gridCardImage: gridCardImages(index),
              gridCardName: gridCardNames[index],
              cardNameMaxLines: cardNameMaxLines,
              cardNameFontSize: cardNameFontSize,
              cardNameFontWeight: cardNameFontWeight,
              cardNameDirection: cardNameDirection,
              onPress: ()=>onPress(index)),
          childCount: gridCardNames.length),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({
    Key? key,
    required this.gridCardImage,
    required this.gridCardName,
    required this.cardNameMaxLines,
    required this.cardNameFontSize,
    required this.cardNameFontWeight,
    required this.cardNameDirection,
    required this.onPress,
  }) : super(key: key);

  final Widget gridCardImage;
  final String gridCardName;
  final int cardNameMaxLines;
  final double cardNameFontSize;
  final FontWeight cardNameFontWeight;
  final TextDirection cardNameDirection;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        elevation: 10,
        color: kCardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(child: gridCardImage),
            Padding(
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
              ),
            )
          ],
        ),
      ),
      onTap: ()=>onPress(),
    );
  }
}




