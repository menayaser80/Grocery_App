import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetables_app/Widget/Empty%20Screen.dart';
import 'package:vegetables_app/Widget/back%20widget.dart';
import 'package:vegetables_app/Widget/text_widget.dart';
import 'package:vegetables_app/provider/order%20provider.dart';
import 'package:vegetables_app/screens/Orders/order%20widget.dart';
import 'package:vegetables_app/servecis/utils.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    // Size size = Utils(context).getScreenSize;
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final ordersList = ordersProvider.getOrders;
    return FutureBuilder(
        future: ordersProvider.fetchOrders(),
        builder: (context, snapshot) {
          return ordersList.isEmpty
              ? const Emptyscreen(
            title: 'You didnt place any order yet',
            subtitle: 'order something and make me happy :)',
           buttontext:  'Shop now',
            imagepath:  'assets/images/cart.png',
          )
              : Scaffold(
              appBar: AppBar(
                leading: const Backwidget(),
                elevation: 0,
                centerTitle: false,
                title: Textwidget(
                  text: 'Your orders (${ordersList.length})',
                  color: color,
                  textsize:  24.0,
                  istitle:  true,
                ),
                backgroundColor: Theme.of(context)
                    .scaffoldBackgroundColor
                    .withOpacity(0.9),
              ),
              body: ListView.separated(
                itemCount: ordersList.length,
                itemBuilder: (ctx, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 2, vertical: 6),
                    child: ChangeNotifierProvider.value(
                      value: ordersList[index],
                      child: const OrderWidget(),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: color,
                    thickness: 1,
                  );
                },
              ));
        });
  }
}
