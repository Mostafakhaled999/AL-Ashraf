import 'dart:ui';
import 'package:flutter/material.dart';

class BlurryBackGround extends StatelessWidget {
  String backGroundImgPath;
  BlurryBackGround({
    required this.backGroundImgPath
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Image(image: AssetImage(
          backGroundImgPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}