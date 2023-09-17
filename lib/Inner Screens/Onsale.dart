import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:vegetables_app/Models/Product_model.dart';
import 'package:vegetables_app/Widget/back%20widget.dart';
import 'package:vegetables_app/Widget/empty%20product.dart';
import 'package:vegetables_app/Widget/onsale_%20widget.dart';
import 'package:vegetables_app/Widget/text_widget.dart';
import 'package:vegetables_app/provider/products_provider.dart';
import 'package:vegetables_app/servecis/utils.dart';

class OnsaleScreen extends StatelessWidget {
  static const routename='/OnsaleScreen';
  const OnsaleScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size=Utils(context).getScreenSize;
    final Color color=Utils(context).color;
    final productprovider=Provider.of<ProductsProvider>(context);
    List<ProductModel>productsonsale=productprovider.getOnSaleProducts;
    return Scaffold(
      appBar: AppBar(
        leading: Backwidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Textwidget(text: 'Producs in sale',color: color,textsize: 24,
        istitle: true,
        ),
      ),
      body: productsonsale.isEmpty?
      EmptyProdwidget(
        text: 'No product on sale yet!\nstay tuned',
      )
          :GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.zero,
        childAspectRatio: size.width/(size.height*0.45),
        children: List.generate(productsonsale.length, (index) {
          return ChangeNotifierProvider.value(
              value: productsonsale[index],
            child:Onsale_widget());
        }),

      ),

    );
  }
}
