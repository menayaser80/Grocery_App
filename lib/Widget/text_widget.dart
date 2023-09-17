import 'package:flutter/material.dart';

class Textwidget extends StatelessWidget {
   Textwidget({Key? key, required this.text, required this.color, required this.textsize,
    this.istitle=false,
    this.Maxlinees=10,
  }) : super(key: key);
final String text;
final Color color;
final double textsize;
bool istitle;
int Maxlinees=10;
  @override
  Widget build(BuildContext context) {
    return Text(
text,
      maxLines: Maxlinees,
      style: TextStyle(
        overflow: TextOverflow.ellipsis,
        color: color,
      fontSize: textsize,
      fontWeight: istitle?FontWeight.bold:FontWeight.normal,
    ),
    );
  }
}
