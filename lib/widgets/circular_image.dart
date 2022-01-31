import 'package:flutter/material.dart';

class CustomCircularImage extends StatelessWidget {
  String imagePath;
  double imageHeightRatio;
  CustomCircularImage({required this.imagePath,this.imageHeightRatio = 0.43});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Image.asset(
        imagePath,
        fit: BoxFit.fitWidth,
        alignment: AlignmentDirectional.topCenter,
        height: MediaQuery.of(context).size.height * imageHeightRatio,
        width: MediaQuery.of(context).size.width,
      ),
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40)),
    );
  }
}