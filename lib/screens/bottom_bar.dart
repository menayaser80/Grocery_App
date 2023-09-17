import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:vegetables_app/provider/DarkThemeProvider.dart';
import 'package:vegetables_app/provider/cart%20provider.dart';
import 'package:vegetables_app/screens/cart/cart%20screen.dart';
import 'package:vegetables_app/screens/category.dart';
import 'package:vegetables_app/screens/home%20Screen.dart';
import 'package:vegetables_app/screens/user.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
int Selectedindex=0;
final  List<Map<String,dynamic>> pages=[
  {
    'page':const Home_Screen(),
  'title':'Home Screen'
  },
  {
    'page': catScreen(),
    'title':'Category Screen',
  },
  {
    'page':const Cart_screen(),
    'title':'Cart Screen',
  },
  {
    'page':const User_screen(),
    'title':'User Screen',
  },
  {
    'id':'123456789',
    'title':'Apricot',
    'price':12.3,
  },
 ];
void Selectedpage(int index){
setState(() {
  Selectedindex=index;
});
}
  @override
  Widget build(BuildContext context) {
    final themeState=Provider.of<DarkThemeProvider>(context);
    final cartProvider=Provider.of<CartProvider>(context);

    bool isdark= themeState.getDarkTheme;
    return Scaffold(

        body:pages[Selectedindex]['page'],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor:isdark
         ? Theme.of(context).cardColor
              :Colors.white,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          currentIndex: Selectedindex,
          unselectedItemColor:isdark?Colors.white10:Colors.black12,
          selectedItemColor:isdark?Colors.lightBlue.shade200:Colors.black87,
          onTap: Selectedpage,
            items:<BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(
             Selectedindex==0?IconlyBold.home: IconlyLight.home,
              ),
                label: 'Home',
              ),
              BottomNavigationBarItem(icon: Icon(
                Selectedindex==1?IconlyBold.category:  IconlyLight.category,
              ),
                label: 'categories',
              ),
              BottomNavigationBarItem(icon:
              // Badge(
              //   toAnimate: true,
              //   shape: BadgeShape.circle,
              //   badgeColor: Colors.blue,
              //   borderRadius: BorderRadius.circular(8),
              //   position: BadgePosition.topEnd(top: -7, end: -7),
              //   badgeContent: FittedBox(
              //       child: Textwidget(
              //           text: '1',
              //           color: Colors.white,
              //           textsize: 15)),
              //   child:
                Icon(
                  Selectedindex==2?IconlyBold.buy: IconlyLight.buy,
                ),

                label: 'Cart',
              ),
              BottomNavigationBarItem(icon: Icon(
                Selectedindex==3?IconlyBold.user2:IconlyLight.user2,
              ),
                label: 'User',
              ),
            ],
        ),
      );

  }
}
