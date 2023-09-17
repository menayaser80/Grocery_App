import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:vegetables_app/Models/Product_model.dart';
import 'package:vegetables_app/Widget/back%20widget.dart';
import 'package:vegetables_app/Widget/empty%20product.dart';
import 'package:vegetables_app/Widget/feed_item.dart';
import 'package:vegetables_app/Widget/text_widget.dart';
import 'package:vegetables_app/provider/products_provider.dart';
import 'package:vegetables_app/servecis/utils.dart';
class FeedsScreen extends StatefulWidget {
  static const routeName = "/FeedsScreenState";
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final TextEditingController? _searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();
  @override
  void dispose() {
    _searchTextController!.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }
  List<ProductModel> listProdcutSearch = [];
//   @override
//   void initState() {
// final productsprovider=Provider.of<ProductsProvider>(context,listen: false);
// productsprovider.fetchProducts();
//     super.initState();
//   }
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productsProvider = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productsProvider.getProducts;
    return Scaffold(
      appBar: AppBar(
        leading: const Backwidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Textwidget(
          text: 'All Products',
          color: color,
          textsize: 20.0,
          istitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: kBottomNavigationBarHeight,
              child: TextField(
                focusNode: _searchTextFocusNode,
                controller: _searchTextController,
                onChanged: (valuee) {
                  setState(() {
                    listProdcutSearch = productsProvider.searchQuery(valuee);
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                    const BorderSide(color: Colors.greenAccent, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                    const BorderSide(color: Colors.greenAccent, width: 1),
                  ),
                  hintText: "What's in your mind",
                  prefixIcon: const Icon(Icons.search),
                  suffix: IconButton(
                    onPressed: () {
                      _searchTextController!.clear();
                      _searchTextFocusNode.unfocus();
                    },
                    icon: Icon(
                      Icons.close,
                      color: _searchTextFocusNode.hasFocus ? Colors.red : color,
                    ),
                  ),
                ),
              ),
            ),
          ),
          _searchTextController!.text.isNotEmpty && listProdcutSearch.isEmpty
              ? const EmptyProdwidget(
              text: 'No products found, please try another keyword')
              : GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            padding: EdgeInsets.zero,
            // crossAxisSpacing: 10,
            childAspectRatio: size.width / (size.height * 0.61),
            children: List.generate(
                _searchTextController!.text.isNotEmpty
                    ? listProdcutSearch.length
                    : allProducts.length, (index) {
              return ChangeNotifierProvider.value(
                value: _searchTextController!.text.isNotEmpty
                    ? listProdcutSearch[index]
                    : allProducts[index],
                child: const FeedWidget(),
              );
            }),
          ),
        ]),
      ),
    );
  }
}
