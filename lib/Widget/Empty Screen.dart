import 'package:flutter/material.dart';
import 'package:vegetables_app/Inner%20Screens/feed%20Screen.dart';
import 'package:vegetables_app/Widget/text_widget.dart';
import 'package:vegetables_app/servecis/global%20method.dart';
import 'package:vegetables_app/servecis/utils.dart';


class Emptyscreen extends StatelessWidget {
  final String imagepath,title,subtitle,buttontext;
  const Emptyscreen({Key? key, required this.imagepath, required this.title, required this.subtitle, required this.buttontext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size=Utils(context).getScreenSize;
    final themestate=Utils(context).getTheme;
    final Color color=Utils(context).color;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
Image.asset(imagepath,width: double.infinity,
height: size.height*0.4,
),
              SizedBox(
                height: 10,
              ),
              Text('Whoops!',style: TextStyle(
                color: Colors.red,
                fontSize: 40,
                fontWeight: FontWeight.w700,
              ),),
              SizedBox(
                height: 20,
              ),
              Textwidget(text: title, color: Colors.cyan, textsize:20,),
              SizedBox(
                height: 20,
              ),
              Textwidget(text: subtitle, color: Colors.cyan, textsize:20,),
              SizedBox(
                height: size.height*0.1,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color:color,
                      ),
                    ),
                    primary: Theme.of(context).colorScheme.secondary,
                    onPrimary: color,
                    padding: EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),

                  ),
                  onPressed: (){
                navigateTo(context, FeedsScreen());
              }, child:Textwidget(
                text: buttontext,
                textsize: 20,
                color: themestate?Colors.grey.shade300:Colors.grey.shade800,
                istitle: true,
              ), )
            ],
          ),
        ),
      ),
    );
  }
}
