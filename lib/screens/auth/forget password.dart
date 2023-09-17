import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vegetables_app/Constants/firebase%20constants.dart';
import 'package:vegetables_app/Constants/swipper.dart';
import 'package:vegetables_app/Widget/Auth%20btn.dart';
import 'package:vegetables_app/Widget/back%20widget.dart';
import 'package:vegetables_app/Widget/text_widget.dart';
import 'package:vegetables_app/screens/loading%20manager.dart';
import 'package:vegetables_app/servecis/global%20method.dart';
import 'package:vegetables_app/servecis/utils.dart';


class ForgetPasswordScreen extends StatefulWidget {
  static const routeName = '/ForgetPasswordScreen';
  const ForgetPasswordScreen({Key? key}) : super(key: key);
  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}
class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final emailTextController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    emailTextController.dispose();
    super.dispose();
  }
  void forgetPassFCT() async {
    if (emailTextController.text.isEmpty ||
        !emailTextController.text.contains("@")) {
      errorDialog(
          subtitle: 'Please enter a correct email address', context: context);
    } else {
      setState(() {
        _isLoading = true;
      });
      try {
        await authInstance.sendPasswordResetEmail(
            email: emailTextController.text.toLowerCase());
        Fluttertoast.showToast(
          msg: "An email has been sent to your email address",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey.shade600,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } on FirebaseException catch (error) {
        errorDialog(
            subtitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        errorDialog(subtitle: '$error', context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Stack(
          children: [
            Swiper(
              itemBuilder: (BuildContext context, int index) {
                return Image.asset(
                  Constantt.authImagesPaths[index],
                  fit: BoxFit.cover,
                );
              },
              autoplay: true,
              itemCount: Constantt.authImagesPaths.length,
            ),
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  const Backwidget(),
                  const SizedBox(
                    height: 20,
                  ),
                  Textwidget(
                    text: 'Forget password',
                    color: Colors.white,
                    textsize: 30,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: emailTextController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Email address',
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AuthButton(
                    buttonText: 'Reset now',
                    fct: () {
                      forgetPassFCT();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
