
import 'package:flutter/cupertino.dart';
import 'package:vegetables_app/Models/viewed_model.dart';

class ViewedProvider with ChangeNotifier {
  Map<String, ViewedProdModel> _ViewedProdlistItems = {};

  Map<String, ViewedProdModel> get getViewedlistItems {
    return _ViewedProdlistItems;
  }

  void addproductToHistory({required String productId}) {
       _ViewedProdlistItems.putIfAbsent(productId, () => ViewedProdModel(
          id: DateTime.now().toString(),
          productId: productId));

    notifyListeners();
  }

  void clearHistory() {
    _ViewedProdlistItems.clear();
    notifyListeners();
  }
}
