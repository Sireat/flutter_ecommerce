import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<ProductEntity, int> _items = {};

  Map<ProductEntity, int> get items => _items;

  int get itemCount => _items.values.fold(0, (sum, quantity) => sum + quantity);

  double get totalPrice {
    return _items.entries.fold(
      0.0,
      (total, entry) => total + entry.key.price * entry.value,
    );
  }

  void addToCart(ProductEntity product) {
    if (_items.containsKey(product)) {
      _items[product] = _items[product]! + 1;
    } else {
      _items[product] = 1;
    }
    notifyListeners();
  }

  void removeFromCart(ProductEntity product) {
    if (_items.containsKey(product)) {
      if (_items[product]! > 1) {
        _items[product] = _items[product]! - 1;
      } else {
        _items.remove(product);
      }
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
