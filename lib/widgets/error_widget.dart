import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AutoSizeText(
        'حدث خطأ حاول فى وقت لاحق',
        maxLines: 2,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      ),
    );
  }
}
