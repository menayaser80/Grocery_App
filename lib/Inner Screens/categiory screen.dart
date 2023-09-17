import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:vegetables_app/Models/Product_model.dart';
import 'package:vegetables_app/Widget/back%20widget.dart';
import 'package:vegetables_app/Widget/empty%20product.dart';
import 'package:vegetables_app/Widget/feed_item.dart';
import 'package:vegetables_app/Widget/text_widget.dart';
import 'package:vegetables_app/provider/products_provider.dart';
import 'package:vegetables_app/servecis/utils.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName='/CategoryScreen';
  const CategoryScreen({Key? key}) : super(key: key);
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}
class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController? SearchController=TextEditingController();
  final FocusNode searchtextnode=FocusNode();
  List<ProductModel>listproductsearch=[];
  @override
  void dispose() {
    SearchController!.dispose();
    searchtextnode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size=Utils(context).getScreenSize;
    final Color color=Utils(context).color;
    final productprovider=Provider.of<ProductsProvider>(context);
    final catName=ModalRoute.of(context)!.settings.arguments as String;
    List<ProductModel>productsbycat=productprovider.findByCategory(catName);
    return Scaffold(
      appBar: AppBar(
        leading: Backwidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Textwidget(text: catName,color: color,textsize: 20,
          istitle: true,
        ),
      ),
      body:productsbycat.isEmpty?EmptyProdwidget(
        text: 'No products belong to this category',
      )
          :SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: kBottomNavigationBarHeight,
                child: TextField(
                  focusNode: searchtextnode,
                  controller:SearchController,
                  onChanged: (value){
                    setState(() {
listproductsearch=productprovider.searchQuery(value);
                    });
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color:Colors.greenAccent,width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color:Colors.greenAccent,width: 1),
                    ),
                    hintText: 'What is in your mind',
                    prefixIcon: Icon(Icons.search),
                    suffix: IconButton(onPressed: (){
                      SearchController!.clear();
                      searchtextnode.unfocus();
                    },
                      icon: Icon(
                        Icons.close,
                        color:searchtextnode.hasFocus? Colors.red:color,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SearchController!.text.isNotEmpty &&listproductsearch.isEmpty?
            EmptyProdwidget(text: 'No product found,please try another keyword')
            :GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              childAspectRatio: size.width/(size.height*0.57),
              children: List.generate(
                  SearchController!.text.isNotEmpty?listproductsearch.length
                      : productsbycat.length , (index) {
                return ChangeNotifierProvider.value(
                  value: SearchController!.text.isNotEmpty?listproductsearch[index]
                      : productsbycat[index],
                  child: FeedWidget(),
                );
              }),
            ),

          ],
        ),
      ),

    );
  }
}
