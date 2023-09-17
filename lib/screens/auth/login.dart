import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vegetables_app/Constants/firebase%20constants.dart';
import 'package:vegetables_app/Constants/swipper.dart';
import 'package:vegetables_app/Widget/Auth%20btn.dart';
import 'package:vegetables_app/Widget/google%20btn.dart';
import 'package:vegetables_app/Widget/text_widget.dart';
import 'package:vegetables_app/fetch%20screen.dart';
import 'package:vegetables_app/screens/auth/Register.dart';
import 'package:vegetables_app/screens/bottom_bar.dart';
import 'package:vegetables_app/screens/loading%20manager.dart';
import 'package:vegetables_app/servecis/global%20method.dart';


class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailTextController = TextEditingController();
  final passTextController = TextEditingController();
  final passFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  var obscureText = true;
  @override
  void dispose() {
    emailTextController.dispose();
    passTextController.dispose();
    passFocusNode.dispose();
    super.dispose();
  }
  bool _isLoading = false;
  void submitFormOnLogin() async {
    final isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      formKey.currentState!.save();
      setState(() {
        _isLoading=true;
      });
      try
      {
        await authInstance.signInWithEmailAndPassword(
            email:emailTextController.text.toLowerCase().trim() ,
            password:passTextController.text.trim());
        navigateTo(context, FetchScreen());
        print('succesfully logged in');
      }
      on FirebaseException catch(error)
      {
        errorDialog(
          subtitle:'${error.message}' ,
          context:context,
        );
        setState(() {
          _isLoading=false;
        });
      } catch(error)
      {
        errorDialog(
          subtitle:'$error' ,
          context:context,
        );
        setState(() {
          _isLoading=false;
        });
      }finally{
        setState(() {
          _isLoading=false;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Stack(
          children: [
            Swiper(
              duration: 800,
              autoplayDelay: 8000,
              itemBuilder: (BuildContext context, int index) {
                return Image.asset(
                  Constantt.authImagesPaths[index],
                  fit: BoxFit.cover,
                );
              },
              autoplay: true,
              itemCount:Constantt.authImagesPaths.length,
            ),
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 120,
                    ),
Textwidget(text: 'Welcome Back', color: Colors.white , textsize:30,istitle: true,),
                    SizedBox(
                      height: 8,
                    ),
                    Textwidget(text: 'Sign in to continue', color: Colors.white , textsize:18,istitle: false,),
                    SizedBox(
                      height: 30,
                    ),
                    Form(
                        key: formKey,
                        child:Column(
                          children: [
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete:()=>FocusScope.of(context).requestFocus(passFocusNode),
                              controller: emailTextController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value){
                                if(value!.isEmpty || !value.contains('@')){
return 'Please enter a valid email address';
                                }else
                                  {
                                    return null;
                                  }
                              },
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle:TextStyle(
                                  color: Colors.white,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.done,
                              onEditingComplete:(){
                                submitFormOnLogin();
                              },
                              controller: passTextController,
                              focusNode: passFocusNode,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: obscureText,
                              validator: (value){
                                if(value!.isEmpty || value.length<7){
                                  return 'Please enter a valid Password';
                                }else
                                {
                                  return null;
                                }
                              },
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              decoration:  InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      obscureText=!obscureText;
                                    });
                                  },
                                  child: Icon(
                                    obscureText?
                                    Icons.visibility:Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                ),
                                hintText: 'Password',
                                hintStyle:TextStyle(
                                  color: Colors.white,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(onPressed: (){}, child: Text(
                        'Forget password?',
                        maxLines: 1,
                          style: TextStyle(
                            color: Colors.lightBlue,
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                            fontStyle: FontStyle.italic,
                          ),
                      ),),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AuthButton(
                      fct: (){
submitFormOnLogin();
                      },
                      buttonText: 'Login',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GoogleButton(),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.white,
                            thickness: 2,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Textwidget(text: 'OR', color:Colors.white, textsize: 18),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.white,
                            thickness: 2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AuthButton(fct: (){
                      navigateTo(context, FetchScreen());
                    }, buttonText: 'Continue as a Guest',
                    primary: Colors.black,),
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                        text:TextSpan(
                          text: 'Don\'t have an account?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          children: [
                           TextSpan(
                             text: '   Sign up',
                             style: TextStyle(
                               color: Colors.lightBlue,
                               fontSize: 18,
                               fontWeight: FontWeight.w600,
                             ),
                             recognizer: TapGestureRecognizer()..onTap=(){
navigateTo(context, RegisterScreen());
                             },
                           ),
                          ]
                        ), ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
