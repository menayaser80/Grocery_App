import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vegetables_app/Constants/firebase%20constants.dart';
import 'package:vegetables_app/Widget/Empty%20Screen.dart';
import 'package:vegetables_app/Widget/text_widget.dart';
import 'package:vegetables_app/provider/cart%20provider.dart';
import 'package:vegetables_app/provider/order%20provider.dart';
import 'package:vegetables_app/provider/products_provider.dart';
import 'package:vegetables_app/screens/cart/cart%20widget.dart';
import 'package:vegetables_app/servecis/global%20method.dart';
import 'package:vegetables_app/servecis/utils.dart';

class Cart_screen extends StatelessWidget {
  const Cart_screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size=Utils(context).getScreenSize;
    final Color color=Utils(context).color;
    final cartProvider=Provider.of<CartProvider>(context);
    final cartItemList=cartProvider.getCartItems.values.toList().reversed.toList();
    return cartItemList.isEmpty?Emptyscreen(
      title:'Your cart is empty',
      subtitle:'Add something and make me happy:)',
      buttontext:'Shop now',
      imagepath:'assets/images/cart.png',

    )
        : Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Textwidget(
            text:'Cart(${cartItemList.length})',
          color: color,
          istitle: true,
          textsize: 22,
        ),
        actions: [
          IconButton(onPressed: (){

            warningDialog(title: 'Empty your cart?', subtitle: 'Are you sure?', fct: ()async{
           await cartProvider.clearOnlineCart();
              cartProvider.clearLocalCart();
            }, context: context);
          }, icon: Icon(
            IconlyBroken.delete,
            color: color,
          ))
        ],
      ),
      body: Column(
        children: [
          checkcut(ctx: context),
          Expanded(
            child: ListView.builder(
              itemCount: cartItemList.length,
              itemBuilder:(ctx,index){
                return ChangeNotifierProvider.value(
                    value: cartItemList[index],
                    child: CartWidget(
                      q: cartItemList[index].quantity,
                    ));
              } ,

            ),
          ),
        ],
      ),

    );
  }
  Widget checkcut({required BuildContext ctx}){
    Size size=Utils(ctx).getScreenSize;
    final Color color=Utils(ctx).color;
    final cartProvider=Provider.of<CartProvider>(ctx);
    final productprovider=Provider.of<ProductsProvider>(ctx);
    final ordersProvider = Provider.of<OrdersProvider>(ctx);
    double total=0.0;
    cartProvider.getCartItems.forEach((key, value) {
      final getcurrentproduct=productprovider.findProdById(value.productId);
      total +=(
          getcurrentproduct.isOnSale?
      getcurrentproduct.salePrice:
      getcurrentproduct.price)*value.quantity;
    });
    return SizedBox(
      width:double.infinity,
      height: size.height*0.1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Material(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: ()async{
                  User? user = authInstance.currentUser;
                  final productProvider =
                  Provider.of<ProductsProvider>(ctx, listen: false);

                  cartProvider.getCartItems.forEach((key, value) async {
                    final getCurrProduct = productProvider.findProdById(
                      value.productId,
                    );
                    try {
                      final orderId = const Uuid().v4();
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(orderId)
                          .set({
                        'orderId': orderId,
                        'userId': user!.uid,
                        'productId': value.productId,
                        'price': (getCurrProduct.isOnSale
                            ? getCurrProduct.salePrice
                            : getCurrProduct.price) *
                            value.quantity,
                        'totalPrice': total,
                        'quantity': value.quantity,
                        'imageUrl': getCurrProduct.imageUrl,
                        'userName': user.displayName,
                        'orderDate': Timestamp.now(),
                      });
                      await cartProvider.clearOnlineCart();
                      cartProvider.clearLocalCart();
                      ordersProvider.fetchOrders();
                      await Fluttertoast.showToast(
                        msg: "Your order has been placed",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                      );
                    } catch (error) {
                      errorDialog(
                          subtitle: error.toString(), context: ctx);
                    } finally {}
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Textwidget(
                    textsize:20 ,
                    text: 'Order Now',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Spacer(),
            FittedBox(child: Textwidget(text: 'Total: \$${total.toStringAsFixed(2)}', color: color, textsize: 18,istitle: true,))
          ],
        ),
      ),
    );

  }
}
