import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import 'package:provider/provider.dart';
import 'package:vegetables_app/Constants/firebase%20constants.dart';
import 'package:vegetables_app/Widget/heart_btn.dart';
import 'package:vegetables_app/Widget/text_widget.dart';
import 'package:vegetables_app/provider/Viewed%20provider.dart';
import 'package:vegetables_app/provider/cart%20provider.dart';
import 'package:vegetables_app/provider/products_provider.dart';
import 'package:vegetables_app/provider/wishlist%20provider.dart';
import 'package:vegetables_app/servecis/global%20method.dart';
import 'package:vegetables_app/servecis/utils.dart';

class Product_Details extends StatefulWidget {
  static const routename='/Product_Details';
  const Product_Details({Key? key}) : super(key: key);

  @override
  State<Product_Details> createState() => _Product_DetailsState();
}

class _Product_DetailsState extends State<Product_Details> {
  final quantitytextcontroller=TextEditingController(text: '1');
  @override
  void dispose() {
    quantitytextcontroller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final Color color=Utils(context).color;
    Size size=Utils(context).getScreenSize;
    final productId=ModalRoute.of(context)!.settings.arguments as String;
    final productprovider=Provider.of<ProductsProvider>(context);
    final cartProvider=Provider.of<CartProvider>(context);
    final wishlistprovider=Provider.of<WishlistProvider>(context);
    final getcurrentproduct=productprovider.findProdById(productId);
    double usedprice=getcurrentproduct.isOnSale
        ?getcurrentproduct.salePrice
        :getcurrentproduct.price;
    double totalprice=usedprice * int.parse(quantitytextcontroller.text);
    bool? isinCart=cartProvider.getCartItems.containsKey(getcurrentproduct.id);
    bool? isinwishlist=wishlistprovider.getWishlistItems.containsKey(getcurrentproduct.id);
    final viewedProvider = Provider.of<ViewedProvider>(context);
    return WillPopScope(
      onWillPop: () async{
viewedProvider.addproductToHistory(productId: productId);
return true;
      },
      child: Scaffold(
appBar: AppBar(
leading: InkWell(
  borderRadius: BorderRadius.circular(12),
  onTap: (){
      Navigator.canPop(context)?Navigator.pop(context):null;
  },
  child: Icon(
      IconlyLight.arrowLeft2,
      color: color,
      size: 24,
  ),
),
  elevation: 0,
  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
),
        body: Column(
          children: [
            Flexible(
                flex: 2,
                child: FancyShimmerImage(
                  imageUrl:getcurrentproduct.imageUrl,
                  boxFit: BoxFit.scaleDown,
                  width: size.width,
                ),
            ),
            Flexible(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.only(
                      topRight:Radius.circular(40),
                      topLeft:Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding:EdgeInsets.only(top: 20,left: 30,right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                child:Textwidget(
                                  color: color,
                                  text: getcurrentproduct.title,
                                  textsize: 25,
                                  istitle: true,
                                ),),
                            HeartBTN(

                              productId:getcurrentproduct.id,
                              isInWishlist: isinwishlist ,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20,left: 30,right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
Textwidget(text:'\$${usedprice.toStringAsFixed(2)}/',
  color: Colors.green, textsize: 22,istitle: true,),
                            Textwidget(text:getcurrentproduct.isPiece?'piece':'/Kg', color: color, textsize: 12,istitle: false,),
                            SizedBox(
                              width: 10,
                            ),
                            Visibility(
                                visible: getcurrentproduct.isOnSale?true:false,
                                child:Text(
'\$${getcurrentproduct.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: color,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                            ),
Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color:Color.fromRGBO(63, 200,101, 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Textwidget(
                                text: 'Free Delievery',
                                color: Colors.white,
                                textsize: 20,
                                istitle: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          quantitycontroller(
                            fct: (){
                              if(quantitytextcontroller.text=='1')
                              {
                                return;
                              }else
                              {
                                setState(() {
                                  quantitytextcontroller.text=(int.parse(quantitytextcontroller.text)-1).toString();
                                });
                              }
                            },
                            icon: CupertinoIcons.minus,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Flexible(
                              flex: 1,
                              child:TextField(
                                controller: quantitytextcontroller,
                                key: ValueKey('quantity'),
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                ),
                                textAlign: TextAlign.center,
                                cursorColor: Colors.green ,
                                enabled: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                ],
                                onChanged: (value){
                                  setState(() {
                                    if(value.isEmpty)
                                      {
                                        quantitytextcontroller.text='1';
                                      }else
                                        {
print('mena');
                                        }
                                  });
                                },
                              ), ),
                          SizedBox(
                            width: 5,
                          ),
                          quantitycontroller(
                            fct: (){
                              setState(() {
                                quantitytextcontroller.text=(int.parse(quantitytextcontroller.text)+1).toString();
                              });

                            },
                            icon: CupertinoIcons.plus,
                            color: Colors.green,
                          ),
                        ],
                      ),
                      Spacer(),
                      Container(
                        width: size.width,
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 30,
                      ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
Flexible(child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
      Textwidget(text: 'Total', color:Colors.red.shade300, textsize: 20,istitle: true,),
      SizedBox(
        height: 5,
      ),
      FittedBox(
        child: Row(
          children: [
            Textwidget(text: '\$${totalprice.toStringAsFixed(2)}/', color: color, textsize: 20,istitle: true,),
            Textwidget(text: '${quantitytextcontroller.text}Kg', color: color, textsize: 16,istitle: false,)
          ],
        ),
      ),
  ],
),),
                            SizedBox(
                              width: 8,
                            ),
                            Flexible(child: Material(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                onTap:isinCart?null
                                        :()async{
                                  final User? user=authInstance.currentUser;
                                  if(user==null)
                                  {
                                    errorDialog(subtitle: 'No user found,please login first', context: context);
                                    return;
                                  }
                                  await GlobalMethods.addTocart(
                                    productId:getcurrentproduct.id,
                                    quantity: int.parse(quantitytextcontroller.text),
                                    context:context,
                                  );
                                  await cartProvider.fetchCart();
                                  },
                                borderRadius: BorderRadius.circular(10),
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                child: Textwidget(
                                  text:isinCart?'InCart': 'Add to cart',
                                  color: Colors.white,
                                  textsize: 18,
                                ),
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
  Widget quantitycontroller({
    required VoidCallback fct,
    required IconData icon,
    required Color color,
  })
  {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: fct,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(icon,color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );

  }
}
