import 'package:flutter/cupertino.dart';

class OrderModel with ChangeNotifier {
  final String orderId, userId, productId, userName, price, imageUrl, quantity;
  // final Timestamp orderDate;

  OrderModel(
      {required this.orderId,
      required this.userId,
      required this.productId,
      required this.userName,
      required this.price,
      required this.imageUrl,
      required this.quantity,
      });
}
