import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:vegetables_app/Constants/swipper.dart';
import 'package:vegetables_app/Inner%20Screens/Onsale.dart';
import 'package:vegetables_app/Inner%20Screens/feed%20Screen.dart';
import 'package:vegetables_app/Models/Product_model.dart';
import 'package:vegetables_app/Widget/feed_item.dart';
import 'package:vegetables_app/Widget/onsale_%20widget.dart';
import 'package:vegetables_app/Widget/text_widget.dart';
import 'package:vegetables_app/provider/products_provider.dart';
import 'package:vegetables_app/servecis/global%20method.dart';
import 'package:vegetables_app/servecis/utils.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({Key? key}) : super(key: key);
  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final themeState = utils.getTheme;
    Size size = Utils(context).getScreenSize;
    final Color color=Utils(context).color;
    final productprovider=Provider.of<ProductsProvider>(context);
    List<ProductModel>allproducts=productprovider.getProducts;
    List<ProductModel> productsonsale=productprovider.getOnSaleProducts;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.33,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    Constantt.offerimage[index],
                    fit: BoxFit.fill,
                  );
                },
                autoplay: true,
                itemCount:Constantt.offerimage.length,
                pagination: SwiperPagination(
                  alignment: Alignment.bottomCenter,
                  builder: DotSwiperPaginationBuilder(
                    color: Colors.white,
                    activeColor: Colors.red,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            TextButton(
                onPressed: () {
                  GlobalMethods.navigateTo(
                      ctx: context, routeName: OnsaleScreen.routename);
                },
                child: Textwidget(
                  text: 'View all',
                  Maxlinees: 1,
                  color: Colors.blue,
                  textsize: 20,
                )),
            SizedBox(
              height: 6,
            ),
            Row(
              children: [
                RotatedBox(
                  quarterTurns: -1,
                  child: Row(
                    children: [
                      Textwidget(text:'on sale'.toUpperCase(),color:Colors.red, textsize:22,istitle: true,),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(IconlyLight.discount,color: Colors.red,)
                    ],
                  ),
                ),
                SizedBox(width: 8,),
                Flexible(
                  child: SizedBox(
                    height: size.height * 0.24,
                    child: ListView.builder(
                        itemCount: productsonsale.length<10
                        ?productsonsale.length
                        :10,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return ChangeNotifierProvider.value(
                              value:productsonsale[index],
                              child: Onsale_widget());
                        }),
                  ),
                ),

              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Textwidget(text: 'Our products', color: color, textsize: 22,istitle: true,),
                  TextButton(
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context, routeName: FeedsScreen.routeName);
                        },
                      child: Textwidget(
                        text: 'Browse all',
                        Maxlinees: 1,
                        color: Colors.blue,
                        textsize: 20,
                      )),
                ],
              ),
            ),
GridView.count(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  crossAxisCount: 2,
padding: EdgeInsets.zero,
// crossAxisSpacing: 10,
childAspectRatio: size.width/(size.height*0.57),
  children: List.generate(
      allproducts.length<4?
      allproducts.length:
      4 , (index) {
    return ChangeNotifierProvider.value(
      value: allproducts[index],
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
