import 'package:flutter/material.dart';
import 'package:ninan/models/product.dart';

class ProductState extends ChangeNotifier {
  Product _currentProduct;

  void setCurrentProduct(Product product) {
    _currentProduct = product;
    notifyListeners();
  }

  Product get currentProduct => _currentProduct;

  get choppingList => null;

  get encapsulationList => null;

  get headAndSeatList => null;

  get rumenAndInsistenceList => null;

  void updateChangesOnChoppingList(int index) {}

  void updateTotalCost() {}

  void updateChangesOnHeadAndSeatList(int index) {}

  void updateChangesOnEncapsulationList(int index) {}

  void updateChangesOnRumenAndInsistenceList(int index) {}

  void increaseTotalCart() {}

  void setProductId(String adsMtgerId) {}

  void setProductTitle(String adsMtgerName) {}
}
