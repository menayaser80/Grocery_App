import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:vegetables_app/Constants/firebase%20constants.dart';
import 'package:vegetables_app/Widget/text_widget.dart';
import 'package:vegetables_app/provider/DarkThemeProvider.dart';
import 'package:vegetables_app/screens/Orders/order%20screen.dart';
import 'package:vegetables_app/screens/Wishlist/wishlist%20screen.dart';
import 'package:vegetables_app/screens/auth/forget%20password.dart';
import 'package:vegetables_app/screens/auth/login.dart';
import 'package:vegetables_app/screens/loading%20manager.dart';
import 'package:vegetables_app/screens/viewed/viewed%20screen.dart';
import 'package:vegetables_app/servecis/global%20method.dart';

class User_screen extends StatefulWidget {
  const User_screen({Key? key}) : super(key: key);

  @override
  State<User_screen> createState() => _User_screenState();
}

class _User_screenState extends State<User_screen> {
  final TextEditingController _addressTextController=
  TextEditingController(text: '');
  @override
  void dispose() {
    _addressTextController.dispose();
super.dispose();
  }
  String? _email;
  String? _name;
  String? address;
  bool _isLoading = false;
  final User? user=authInstance.currentUser;
  @override
  void initState() {
    getUserData();
    super.initState();
  }
  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      String _uid = user!.uid;

      final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if (userDoc == null) {
        return;
      } else {
        _email = userDoc.get('email');
        _name = userDoc.get('name');
        address = userDoc.get('shopping_address');
        _addressTextController.text = userDoc.get('shopping_address');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      errorDialog(subtitle: '$error', context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final themeState=Provider.of<DarkThemeProvider>(context);
    final Color color=themeState.getDarkTheme?Colors.white:Colors.black;
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Center(
          child: SingleChildScrollView(
            child:Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 15.0,
                  ),
                  RichText(text:TextSpan(text:'Hi,  ',
                    style: TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold,
                  fontSize: 27.0,
                  ),children: <TextSpan>[
                    TextSpan(
                      text: _name == null?'user':_name,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontSize: 25.0,
                      ),
                      recognizer: TapGestureRecognizer()..onTap=(){
                      }
                    ),
                  ],
                  ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Textwidget(
                    text:_email == null?'Email':_email!,
                      color: color,
                      textsize: 18.0,

                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Divider(
                    thickness: 2.0,
                  ),
SizedBox(
  height: 20.0,
),
listtile(
    title:'Address 2',
    subtitle: address,
    icon:IconlyLight.profile,
    color: color,
    onpressed: ()async{
        await showAdressDialog();
        },
),
                  listtile(
                      title:'Orders',
                      icon:IconlyLight.profile,
                      onpressed: (){
                        navigateTo(context,OrdersScreen());

                      },
                  color: color,
                  ),
                  listtile(
                      title:'Wishlist',
                      icon:IconlyLight.heart,
                      onpressed: (){
                        navigateTo(context,Wishlistscreen());
                      },
                    color: color,
                  ),

                  listtile(
                      title:'Viewed',
                      color: color,
                      icon:IconlyLight.show,
                      onpressed: (){
                        navigateTo(context, ViewedRecentlyScreen());
                      }),
                  listtile(
                      title:'Forget password',
                      icon:IconlyLight.unlock,
                      color: color,
                      onpressed: (){
                        navigateTo(context, ForgetPasswordScreen());
                      }),
                  SwitchListTile(
                    title:Textwidget(
                      text:themeState.getDarkTheme?'DarkMode':'LightMode',
                      color: color,
                      textsize: 18.0,
                    ),
                    secondary: Icon(
                        themeState.getDarkTheme?Icons.dark_mode_outlined
                            :Icons.light_mode_outlined),
                    value:themeState.getDarkTheme ,
                    onChanged: (bool value){
                      setState(() {
                        themeState.setDarkTheme=value;
                      });
                    },
                  ),
                  listtile(
                      title:user==null?'Login':'LogOut',
                      icon:user==null?IconlyLight.login:IconlyLight.logout,
                      color: color,
                      onpressed: (){
                        if(user==null)
                        {
                          navigateTo(context, LoginScreen());
                          return;
                        }
warningDialog(title: 'Sign out', subtitle: 'Do you want sign out?', fct:()async{
   await authInstance.signOut();
   navigateTo(context, LoginScreen());
}, context: context);
                 }
                      ),




                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<void>showLogoutDialog()async {
  await showDialog(context: context, builder: (context){
    return AlertDialog(
      title: Row(
        children: [
          Image.asset('assets/images/sign.png',height: 20.0,width: 20.0,fit: BoxFit.fill,),
          SizedBox(width: 10.0,),
          Text('Sign Out'),
        ],
      ),
      content: Text('Do you want sign out?'),
      actions: [
        TextButton(onPressed: (){
          if(Navigator.canPop(context))
            {
              Navigator.pop(context);
            }
          }, child:Textwidget(
          color: Colors.cyan,
          text: 'Cancel',
          textsize: 18,
        ),),
        TextButton(onPressed: (){

        }, child:Textwidget(
    color: Colors.red,
    text: 'ok',
    textsize: 18,
    ),

    ),
      ],
    );
  });
  }
    Future<void>showAdressDialog()async{
    await showDialog(
        context:context,
        builder:(context){
          return AlertDialog(
            title: Text('Update'),
            content: TextField(
              controller: _addressTextController,
              onChanged: (value){
print('${_addressTextController.text}');              },
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Your Address',
              ),
            ),
            actions: [
              TextButton(onPressed: ()async{
                String _uid =user!.uid;
                try{
                  await FirebaseFirestore.instance.collection('users').doc(_uid).update({
                    'shopping_address':_addressTextController.text,
                  });
                  Navigator.pop(context);
                  setState(() {
                    address=  _addressTextController.text;
                  });
                }
                    catch(error){
                  errorDialog(subtitle: error.toString(), context: context);
                    }
              }, child:Text('Update'))
            ],
          );
        }
    );
  }

  Widget listtile({
  required String title,
    required IconData icon,
     String? subtitle,
    required Function onpressed,
    required Color color,

  })
  {
    return ListTile(
      title: Textwidget(
        color: color,
        text:title,
        textsize:22.0,
        // istitle: true,
      ),
      subtitle: Textwidget(
        color: color,
        text:subtitle==null?"":subtitle,
        textsize:18.0,
      ),
      leading: Icon(icon),
      trailing: Icon(IconlyLight.arrowRight2),
      onTap: (){
        onpressed();
      },
    );

  }
}
