import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:vegetables_app/Constants/firebase%20constants.dart';
import 'package:vegetables_app/Constants/swipper.dart';
import 'package:vegetables_app/provider/cart%20provider.dart';
import 'package:vegetables_app/provider/order%20provider.dart';
import 'package:vegetables_app/provider/products_provider.dart';
import 'package:vegetables_app/provider/wishlist%20provider.dart';
import 'package:vegetables_app/screens/bottom_bar.dart';
import 'package:vegetables_app/servecis/global%20method.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({Key? key}) : super(key: key);

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  List<String>images=Constantt.authImagesPaths;
  @override
  void initState() {
    images.shuffle();
Future.delayed(const Duration(microseconds: 5),()async{
  final productsprovider=Provider.of<ProductsProvider>(context,listen: false);
  final cartprovider=Provider.of<CartProvider>(context,listen: false);
    final wishlistprovider=Provider.of<WishlistProvider>(context,listen: false);
  final orderprovider=Provider.of<OrdersProvider>(context,listen: false);

  final User?user=authInstance.currentUser;
  if(user==null)
    {
      await  productsprovider.fetchProducts();
      cartprovider.clearLocalCart();
      wishlistprovider.clearLocalWishlist();
      orderprovider.clearLocalorders();
    }
  else
    {
      await  productsprovider.fetchProducts();
       await cartprovider.fetchCart();
       await wishlistprovider.fetchWishlist();
    }
  navigateTo(context, BottomBarScreen());
});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
body: Stack(
  children: [
    Image.asset(images[0],fit: BoxFit.cover,height: double.infinity,),
    Container(
      color: Colors.black.withOpacity(0.7),
    ),
    Center(
      child: SpinKitFadingFour(
        color: Colors.white,
      ),
    ),
  ],
),
    );
  }
}
