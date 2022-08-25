import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/cart_item.dart';
import 'package:http/http.dart';

import '../provider/cart.dart';

class OrderItem {
  final String id;
  
  final double amount;
  final List<cartItem> products;
  final DateTime dateTime;
  OrderItem({this.id, this.amount, this.products, this.dateTime});
}

class Order with ChangeNotifier {
  List<OrderItem> _order = [];
  final String _authToken;
  final String _userId;
  Order(this._authToken,this._userId, this._order);
  List<OrderItem> get order {
    return [..._order];
  }

  Future<void> FetchSetdata() async {
    final url =
        Uri.https('ganesh-flutter-default-rtdb.firebaseio.com', '/orders/$_userId.json?auth=$_authToken');
    final response = await get(
      url,
    );

    final List<OrderItem> Loadedorders = [];
    final extraxtedproduct = json.decode(response.body) as Map<String, dynamic>;
    if (extraxtedproduct == null) {
      return;
    }
    extraxtedproduct.forEach((orderid, orderProduct) {
      Loadedorders.add(
        OrderItem(
          id: orderid,
          amount: orderProduct['amount'],
          dateTime: DateTime.parse(orderProduct['datetime']),
          products: (orderProduct['products'] as List<dynamic>)
              .map(
                (item) => cartItem(
                  id: item['id'],
                  title: item['title'],
                  price: item['price'],
                  quantity: item['quantity'],
                ),
              )
              .toList(),
        ),
      );
    });
    _order = Loadedorders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<cartItem> cartProducts, double total) async {
    final url =
        Uri.https('ganesh-flutter-default-rtdb.firebaseio.com', '/orders/$_userId.json?auth=$_authToken');
    final timeStamp = DateTime.now();
    final response = await post(
      url,
      body: json.encode({
        'amount': total,
        'datetime': timeStamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price
                })
            .toList(),
      }),
    );
    _order.insert(
      0,
      OrderItem(
        id: jsonDecode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }
}
