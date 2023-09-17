import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:vegetables_app/servecis/utils.dart';

class Backwidget extends StatelessWidget {
  const Backwidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color=Utils(context).color;
    return InkWell(
      borderRadius: BorderRadius.circular(12.0),
      onTap: (){
        Navigator.pop(context);
      },
      child: Icon(IconlyLight.arrowLeft2,
        color: color,
      ),

    );
  }
}
