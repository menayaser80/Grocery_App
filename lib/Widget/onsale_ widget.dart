import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import 'package:provider/provider.dart';
import 'package:vegetables_app/Constants/firebase%20constants.dart';
import 'package:vegetables_app/Inner%20Screens/Product%20Details.dart';
import 'package:vegetables_app/Models/Product_model.dart';
import 'package:vegetables_app/Widget/heart_btn.dart';
import 'package:vegetables_app/Widget/price_widget.dart';
import 'package:vegetables_app/Widget/text_widget.dart';
import 'package:vegetables_app/provider/cart%20provider.dart';
import 'package:vegetables_app/provider/wishlist%20provider.dart';
import 'package:vegetables_app/servecis/global%20method.dart';
import 'package:vegetables_app/servecis/utils.dart';

class Onsale_widget extends StatefulWidget {
  @override
  State<Onsale_widget> createState() => _Onsale_widgetState();
}

class _Onsale_widgetState extends State<Onsale_widget> {

  @override
  Widget build(BuildContext context) {
    final Color color=Utils(context).color;
    Size size=Utils(context).getScreenSize;
    final theme=Utils(context).getTheme;
    final cartProvider=Provider.of<CartProvider>(context);
    final productmodel=Provider.of<ProductModel>(context);
    final wishlistprovider=Provider.of<WishlistProvider>(context);
    bool? isinwishlist=wishlistprovider.getWishlistItems.containsKey(productmodel.id);
    bool? isinCart=cartProvider.getCartItems.containsKey(productmodel.id);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12.0),
        color: Theme.of(context).cardColor.withOpacity(0.9),
        child: InkWell(
  borderRadius: BorderRadius.circular(12.0),
          onTap: (){
            Navigator.pushNamed(context, Product_Details.routename,
                arguments: productmodel.id
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    FancyShimmerImage(
        imageUrl:productmodel.imageUrl,
      boxFit: BoxFit.fill,
      height: size.width*0.22,
      width: size.width*0.22,

    ),
      Column(
        children: [
  Textwidget(
      text:productmodel.isPiece?'1 Piece':'1KG' ,
      color:color ,
      textsize:17,
      istitle: true,
  ),
          SizedBox(
            height: 6.0,
          ),
          Row(
            children: [
              GestureDetector(
                onTap:isinCart?null
              :()async{
                  final User? user=authInstance.currentUser;
                  if(user==null)
                  {
                    errorDialog(subtitle: 'No user found,please login first', context: context);
                    return;
                  }
               await   GlobalMethods.addTocart(
                    productId:productmodel.id,
                    quantity:1 ,
                    context:context ,
                  );
                 await cartProvider.fetchCart();
                  },
                child: Icon(
                  isinCart? IconlyBold.bag2:
                    IconlyLight.bag2,
                  size: 22,
                  color:isinCart?Colors.green: color,
                ),
              ),
              HeartBTN(
                productId:productmodel.id,
                isInWishlist: isinwishlist ,
              ),
            ],
          ),
        ],
      ),
  ],
),
                PriceWidget(
                  isOnSale: true,
                  price:productmodel.price,
                  salePrice:productmodel.salePrice,
                  textPrice:'1',
                ),
                const SizedBox(
                  height: 5,
                ),
Textwidget(
  text:productmodel.title,
  color:color,
  textsize:16,
  istitle: true,
),

              ],
            ),
          ),
),
      ),
    );
  }
}
