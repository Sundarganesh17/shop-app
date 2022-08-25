import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    @required this.isFavourite = false,
  });
  void _Setfavourite(bool newvalue) {
    isFavourite = newvalue;
    notifyListeners();
  }

  Future<void> toggleFavouriteStatus(String authToken, String userId) async {
    final oleFavourite = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url = Uri.https('ganesh-flutter-default-rtdb.firebaseio.com',
        '/userFavourites/$userId/$id.json?auth=$authToken');
    try {
      final response = await put(
        url,
        body: json.encode(
          isFavourite,
        ),
      );
      if (response.statusCode >= 400) {
        _Setfavourite(oleFavourite);
      }
    } catch (error) {
      _Setfavourite(oleFavourite);
    }
  }
}
