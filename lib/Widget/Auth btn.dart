import 'package:flutter/material.dart';
import 'package:vegetables_app/Widget/text_widget.dart';
 class AuthButton extends StatelessWidget {
  const AuthButton({
    Key? key,
    required this.fct,
    required this.buttonText,
    this.primary = Colors.white38,
  }) : super(key: key);
  final VoidCallback fct;
  final String buttonText;
  final Color primary;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: primary, // background (button) color
          ),
          onPressed: fct,
          child: Textwidget(
            text: buttonText,
            textsize: 18,
            color: Colors.white,
          )),
    );
  }
}
