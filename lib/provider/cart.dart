import 'package:flutter/foundation.dart';

class cartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  cartItem({this.id, this.title, this.quantity, this.price});
}

class Cart with ChangeNotifier {
  Map<String, cartItem> _items = {};
  Map<String, cartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items == null ? 0 : _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(
    String productId,
    String title,
    double price,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (exisitingcartitem) => cartItem(
          id: exisitingcartitem.id,
          title: exisitingcartitem.title,
          price: exisitingcartitem.price,
          quantity: exisitingcartitem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => cartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
  }

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removesingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (exisitingcartitem) => cartItem(
          id: exisitingcartitem.id,
          title: exisitingcartitem.title,
          price: exisitingcartitem.price,
          quantity: exisitingcartitem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
