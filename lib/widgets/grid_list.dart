import 'package:flutter/material.dart';
import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/widgets/grid_card.dart';
import 'package:al_ashraf/models/url_launcher.dart';

class GridList extends StatelessWidget {
  List<String> gridCardNames;
  List<String> gridCardIconsPath;
  List<String> gridCardUrl;
  int numOfCards;

  GridList({required this.gridCardNames,required this.gridCardIconsPath,required this.gridCardUrl,required this.numOfCards});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
              (context, index) => GestureDetector(
            child: GridCard(
                cardNameMaxLines: 2,
                cardNameDirection: TextDirection.ltr,
                cardNameFont: 20,
                cardName: gridCardNames[index],
                cardWidget: Image(
                    image: AssetImage(gridCardIconsPath[index]))),
            onTap: () => UrlLauncher(gridCardUrl[index]),
          ),
          childCount: numOfCards),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}