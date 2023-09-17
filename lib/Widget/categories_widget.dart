import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetables_app/Inner%20Screens/categiory%20screen.dart';
import 'package:vegetables_app/Widget/text_widget.dart';
import 'package:vegetables_app/provider/DarkThemeProvider.dart';
class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget(
      {Key? key,
        required this.catText,
        required this.imgPath,
        required this.passedColor})
      : super(key: key);
  final String catText, imgPath;
  final Color passedColor;
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    final themeState = Provider.of<DarkThemeProvider>(context);
    double _screenWidth = MediaQuery.of(context).size.width;
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, CategoryScreen.routeName,
            arguments:catText
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: passedColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: passedColor.withOpacity(0.7),
            width: 2,
          ),
        ),
        child: Column(children: [
          // Container for the image
          Container(
            height: _screenWidth * 0.3,
            width: _screenWidth * 0.3,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    imgPath,
                  ),
                  fit: BoxFit.fill),
            ),
          ),
          // Category name
          Textwidget(
            textsize: 20,
            istitle: true,
            text: catText,
            color: color,
          ),
        ]),
      ),
    );
  }
}
