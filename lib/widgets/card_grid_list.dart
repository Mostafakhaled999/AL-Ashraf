import 'package:flutter/material.dart';
import 'package:al_ashraf/constants/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
          (context, index) => GestureDetector(
                child: Card(
                  elevation: 10,
                  color: kGridTileColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(child: gridCardImages(index)),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: AutoSizeText(
                          gridCardNames[index],
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
                onTap: () => onPress(index),
              ),
          childCount: gridCardNames.length),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
