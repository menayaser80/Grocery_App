import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:vegetables_app/Constants/firebase%20constants.dart';
import 'package:vegetables_app/Widget/text_widget.dart';

void navigateTo(context,Widget)=>Navigator.push(context, MaterialPageRoute(
  builder:(context)=>Widget,
));
Future<void>warningDialog({
  required String title,
  required String subtitle,
required VoidCallback fct,
required BuildContext context,
})async {
await showDialog(context: context, builder: (context){
return AlertDialog(
title: Row(
children: [
Image.asset('assets/images/sign.png',height: 20.0,width: 20.0,fit: BoxFit.fill,),
SizedBox(width: 8.0,),
Text(title),
],
),
content: Text(subtitle),
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
TextButton(
  onPressed: fct
  ,child:Textwidget(
color: Colors.red,
text: 'ok',
textsize: 18,
),

),
],
);
});
}
Future<void>errorDialog({
  required String subtitle,
  required BuildContext context,
})async {
  await showDialog(context: context, builder: (context){
    return AlertDialog(
      title: Row(
        children: [
          Image.asset('assets/images/sign.png',height: 20.0,width: 20.0,fit: BoxFit.fill,),
          SizedBox(width: 8.0,),
          Text(' An Error occured'),
        ],
      ),
      content: Text(subtitle),
      actions: [
        TextButton(onPressed: (){
          if(Navigator.canPop(context))
          {
            Navigator.pop(context);
          }
        }, child:Textwidget(
          color: Colors.cyan,
          text: 'Ok',
          textsize: 18,
        ),),
      ],
    );
  });
}
class GlobalMethods {
  static navigateTo({required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, routeName);

  }
  static Future<void> addToWishlist(
      {required String productId, required BuildContext context}) async {
    final User? user = authInstance.currentUser;
    final _uid = user!.uid;
    final wishlistId = const Uuid().v4();
    try {
      FirebaseFirestore.instance.collection('users').doc(_uid).update({
        'userWish': FieldValue.arrayUnion([
          {
            'wishlistId': wishlistId,
            'productId': productId,
          }
        ])
      });
      await Fluttertoast.showToast(
        msg: "Item has been added to your wishlist",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } catch (error) {
      errorDialog(subtitle: error.toString(), context: context);
    }
  }
  static Future<void>addTocart({
  required String productId,
    required int quantity,
    required BuildContext context,
})async
  {
    final User?user=authInstance.currentUser;
    final _uid=user!.uid;
    final cartid=const Uuid().v4();
try{
FirebaseFirestore.instance.collection('users').doc(_uid).update({
'userCart':FieldValue.arrayUnion([
  {
'cartId':cartid,
    'productId':productId,
    'quantity':quantity,

  }
])
});
await Fluttertoast.showToast(
    msg:'Item has been added to your cart',
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.CENTER,
);
}
catch(error){
errorDialog(subtitle: error.toString(), context: context);
}
  }
}