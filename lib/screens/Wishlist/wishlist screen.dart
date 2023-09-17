import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:vegetables_app/Widget/Empty%20Screen.dart';
import 'package:vegetables_app/Widget/back%20widget.dart';
import 'package:vegetables_app/Widget/text_widget.dart';
import 'package:vegetables_app/provider/wishlist%20provider.dart';
import 'package:vegetables_app/screens/Wishlist/wishlist%20widget.dart';
import 'package:vegetables_app/servecis/global%20method.dart';
import 'package:vegetables_app/servecis/utils.dart';

class Wishlistscreen extends StatelessWidget {
  static const routename='/Wishlistscreen';
  const Wishlistscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistItemsList =
    wishlistProvider.getWishlistItems.values.toList().reversed.toList();
    return
      wishlistItemsList.isEmpty ?Emptyscreen(
        title:'Your Wishlist Is Empty',
        subtitle:'Explore more and shortlist some items',
        buttontext:'Add to Wish',
        imagepath:'assets/images/wishlist.png',

      ):Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Backwidget(),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Textwidget(
          text: 'Wishlist (${wishlistItemsList.length})',
          color: color,
          istitle: true,
          textsize: 22,
        ),
        actions: [
          IconButton(onPressed: () {
            warningDialog(title: 'Empty your Wishlist?', subtitle: 'Are you sure?', fct: ()async{
              await wishlistProvider.clearOnlineWishlist();
              wishlistProvider.clearLocalWishlist();
              }, context: context);
            }, icon: Icon(
            IconlyBroken.delete,
            color: color,
          ))
        ],
      ),
      body:MasonryGridView.count(
        crossAxisCount: 2,
  itemCount: wishlistItemsList.length,
        itemBuilder: (context, index) {
          return ChangeNotifierProvider.value(
              value: wishlistItemsList[index],
              child: WishlistWidget());
        },
      ),

    );
  }
}