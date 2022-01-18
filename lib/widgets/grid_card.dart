import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:al_ashraf/constants/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';

class GridCard extends StatelessWidget {
  String cardName;
  Widget cardWidget;
  double cardNameFont;
  FontWeight cardNameBold;
  TextDirection cardNameDirection;
  GridCard({
    required this.cardName,
    required this.cardWidget,
    this.cardNameFont = 30,
    this.cardNameBold = FontWeight.bold,
    this.cardNameDirection = TextDirection.rtl
  }) ;

  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 10,
      color: kGridTileColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child:cardWidget ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: AutoSizeText(
              cardName,
              maxLines: 1,
              style: TextStyle(
                fontSize: cardNameFont,
                fontWeight: cardNameBold ,
              ),
              textDirection: cardNameDirection,
              softWrap: true,
              overflow: TextOverflow.clip,
            ),
          )
        ],
      ),
    );
  }
}
