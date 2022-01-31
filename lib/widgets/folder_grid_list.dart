import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class FolderGridList extends StatelessWidget {

  List<String> folderNames;
  List<String> folderIds;
  Function onPress;
  FolderGridList({required this.folderNames,required this.folderIds,required this.onPress});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
              (context, index) => GestureDetector(
            child: Column(
              children: [
                Icon(
                  Icons.folder,
                  size: MediaQuery.of(context).size.width *
                      0.28,
                  color: Color(0xFFFFCF66),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right:8.0,left: 8),
                    child: AutoSizeText(
                      folderNames[index],
                      softWrap: true,
                      textDirection: TextDirection.rtl,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      overflow:TextOverflow.fade,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
            onTap: ()=> onPress(index),
          ),
          childCount: folderNames.length),
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}