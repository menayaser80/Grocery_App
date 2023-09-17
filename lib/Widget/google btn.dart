import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vegetables_app/Constants/firebase%20constants.dart';
import 'package:vegetables_app/Widget/text_widget.dart';
import 'package:vegetables_app/screens/bottom_bar.dart';
import 'package:vegetables_app/servecis/global%20method.dart';


class GoogleButton extends StatelessWidget {
  GoogleButton({Key? key}) : super(key: key);
  bool _isloading = false;

  Future<User?> _googleSignUp(context) async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );
      final FirebaseAuth _auth = FirebaseAuth.instance;

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final User? user = (await _auth.signInWithCredential(credential)).user;

      return user;
    } catch (e) {
      print(e.toString());
    }
  }  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      child: InkWell(
        onTap: () async{
        await  _googleSignUp(context).then((value) {
          navigateTo(context,BottomBarScreen());
        });
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            color: Colors.white,
            child: Image.asset(
              'assets/images/google.png',
              width: 40.0,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Textwidget(
              text: 'Sign in with google', color: Colors.white, textsize: 18)
        ]),
      ),
    );
  }
}