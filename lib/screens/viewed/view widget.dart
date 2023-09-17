import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:vegetables_app/Constants/firebase%20constants.dart';
import 'package:vegetables_app/Models/viewed_model.dart';
import 'package:vegetables_app/Widget/text_widget.dart';
import 'package:vegetables_app/provider/Viewed%20provider.dart';
import 'package:vegetables_app/provider/cart%20provider.dart';
import 'package:vegetables_app/provider/products_provider.dart';
import 'package:vegetables_app/servecis/global%20method.dart';
import 'package:vegetables_app/servecis/utils.dart';
class ViewedRecentlyWidget extends StatefulWidget {
  const ViewedRecentlyWidget({Key? key}) : super(key: key);

  @override
  _ViewedRecentlyWidgetState createState() => _ViewedRecentlyWidgetState();
}

class _ViewedRecentlyWidgetState extends State<ViewedRecentlyWidget> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final viewModel = Provider.of<ViewedProdModel>(context);
    final viewProvider = Provider.of<ViewedProvider>(context);
    final getCurrProduct =
    productProvider.findProdById(viewModel.productId);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isIncart = cartProvider.getCartItems.containsKey(getCurrProduct.id);
    Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
        // GlobalMethods.navigateTo(ctx: context,
        //     routeName: Product_Details.routename);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FancyShimmerImage(
              imageUrl:getCurrProduct.imageUrl,
              boxFit: BoxFit.fill,
              height: size.width*0.27,
              width: size.width*0.25,
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              children: [
                Textwidget(
                  text: getCurrProduct.title,
                  color: color,
                  textsize: 20,
                  istitle: true,
                ),
                const SizedBox(
                  height: 12,
                ),
                Textwidget(
                  text: '\$${usedPrice.toStringAsFixed(2)}',
                  color: color,
                  textsize: 20,
                  istitle:false,
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Material(
                borderRadius: BorderRadius.circular(12),
                color: Colors.green,
                child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap:
                    _isIncart?null
                        :()async{
                      final User? user=authInstance.currentUser;
                      if(user==null)
                      {
                        errorDialog(subtitle: 'No user found,please login first', context: context);
                        return;
                      }
                   await GlobalMethods.addTocart(
                        productId:getCurrProduct.id,
                        quantity:1,
                        context:context,
                      );
                      await cartProvider.fetchCart();
                    },
                    child: Padding(
                      padding:  EdgeInsets.all(8.0),
                      child: Icon(
                        _isIncart? Icons.check:IconlyBold.plus,
                        color: Colors.white,
                        size: 20,
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
