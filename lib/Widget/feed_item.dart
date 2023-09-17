import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vegetables_app/Constants/firebase%20constants.dart';
import 'package:vegetables_app/Inner%20Screens/Product%20Details.dart';
import 'package:vegetables_app/Models/Product_model.dart';
import 'package:vegetables_app/Widget/heart_btn.dart';
import 'package:vegetables_app/Widget/price_widget.dart';
import 'package:vegetables_app/provider/cart%20provider.dart';
import 'package:vegetables_app/provider/wishlist%20provider.dart';
import 'package:vegetables_app/servecis/global%20method.dart';
import 'package:vegetables_app/servecis/utils.dart';

import 'text_widget.dart';

class FeedWidget extends StatefulWidget {
  const FeedWidget({Key? key, }) : super(key: key);
  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  final quantityTextController=TextEditingController();
  @override
  void initState() {
    quantityTextController.text='1';
    super.initState();
  }
  @override
  void dispose() {
quantityTextController.dispose();
super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size=Utils(context).getScreenSize;
    final Color color=Utils(context).color;
    final productmodel=Provider.of<ProductModel>(context);
    final cartProvider=Provider.of<CartProvider>(context);
    final wishlistprovider=Provider.of<WishlistProvider>(context);
    bool? isinCart=cartProvider.getCartItems.containsKey(productmodel.id);
    bool? isinwishlist=wishlistprovider.getWishlistItems.containsKey(productmodel.id);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
          color: Theme.of(context).cardColor,
borderRadius: BorderRadius.circular(12.0),
          child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, Product_Details.routename,
            arguments: productmodel.id
            );
          },
            borderRadius: BorderRadius.circular(12.0),
              child: Column(
              children: [
                FancyShimmerImage(
                  imageUrl:productmodel.imageUrl,
                  boxFit: BoxFit.fill,
                  height: size.width*0.21,
                  width: size.width*0.2,

                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Textwidget(
                            text:productmodel.title ,
                            color:color,
                            Maxlinees: 1,
                            textsize:18,
                          istitle: true,
                        ),
                      ),
                      Flexible(
                          flex: 1,
                          child:
                          HeartBTN(
                            productId:productmodel.id,
                            isInWishlist:isinwishlist ,
                          ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: PriceWidget(
                        isOnSale: productmodel.isOnSale,
                        price:productmodel.price,
                        salePrice:productmodel.salePrice,
                        textPrice:quantityTextController.text,
                      ),
                    ),

Flexible(
  flex: 3,
  child:   Row(
    children: [
      FittedBox(
          child: Textwidget(text:productmodel.isPiece?'piece':'KG', color: color, textsize:18,istitle: true,)),
      SizedBox(
        width: 5,
      ),
  Flexible(
      flex: 2,
      child: TextFormField(
    controller:quantityTextController ,
    key: ValueKey('10'),
    style: TextStyle(
      color: color,
      fontSize: 18
    ),
    enabled: true,
    onChanged: (value){
      setState(() {

      });
    },
    keyboardType: TextInputType.number,
    maxLines: 1,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
    ],
  )),
    ],
  ),
),
                  ],
                ),
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(onPressed:
                    isinCart?null
                      :()async{
                      final User? user=authInstance.currentUser;
                      if(user==null)
                      {
                        errorDialog(subtitle: 'No user found,please login first', context: context);
                        return;
                      }
                     await GlobalMethods.addTocart(
                        productId:productmodel.id,
                        quantity:int.parse(quantityTextController.text) ,
                        context:context,
                      );
                      await cartProvider.fetchCart();
                  }, child: Textwidget(
                    text:isinCart ? 'In cart': 'Add to cart',
                    Maxlinees: 1,
                     color: color,
                    textsize: 20,
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Theme.of(context).cardColor),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.0,),
                          bottomRight:Radius.circular(12.0,),
                        ))
                    ),
                  ),),
                ),
            ],
          ),
          ),
      ),
    );
  }
}
