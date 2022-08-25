import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
  //var _showFavouritiesOnly = false;
  List<Product> get items {
    // if (_showFavouritiesOnly) {
    //   return _items.where((proitm) => proitm.isFavourite).toList();
    // }

    return [..._items];
  }

  List<Product> get Favouriteitems {
    return _items.where((proitem) => proitem.isFavourite).toList();
  }

  final String authToken;
  final String userId;
  Products(this.authToken, this.userId, this._items);

  // void ShowFavourites() {
  //  _showFavouritiesOnly = true;
  //   notifyListeners();
//  }

  // void ShowAll() {
  //  _showFavouritiesOnly = false;
  //  notifyListeners();
  // }
  Future<void> fetchandSetData([bool filterByuser = false]) async {
    final filtterString =
        filterByuser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url = Uri.https('ganesh-flutter-default-rtdb.firebaseio.com',
        '/products.json?auth=$authToken&$filtterString');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final urls = Uri.https('ganesh-flutter-default-rtdb.firebaseio.com',
          '/userFavourites/$userId.json?auth=$authToken');
      final favouriteResponse = await http.get(urls);
      final FavouriteData = json.decode(favouriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((proid, proData) {
        loadedProducts.add(
          Product(
            id: proid,
            title: proData['title'],
            description: proData[' description'],
            price: proData[' price'],
            imageUrl: proData[' imageUrl'],
            isFavourite:
                FavouriteData == null ? false : FavouriteData[proid] ?? false,
          ),
        );
        _items = loadedProducts;
        notifyListeners();
      });
      print(response);
    } catch (error) {
      throw (error);
    }
  }

  Product findById(String id) {
    return _items.firstWhere((pro) => pro.id == id);
  }

  Future<void> addProducts(Product editproducts) async {
    final url = Uri.https('ganesh-flutter-default-rtdb.firebaseio.com',
        '/products.json?auth=$authToken');
    try {
      final Response = await http.post(
        url,
        body: json.encode({
          'title': editproducts.id,
          'description': editproducts.description,
          'imgUrl': editproducts.imageUrl,
          'price': editproducts.price,
          'creatorId': userId,
        }),
      );
      final newProduct = Product(
        title: editproducts.title,
        price: editproducts.price,
        description: editproducts.description,
        imageUrl: editproducts.imageUrl,
        id: json.decode(Response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error();
    }

    // _items.add(value);
  }

  Future<void> updateProducts(String id, Product newproduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.https('ganesh-flutter-default-rtdb.firebaseio.com',
          '/products/$id.json?auth=$authToken');
      await http.patch(url,
          body: jsonEncode({
            'title': newproduct.title,
            'description': newproduct.description,
            'price': newproduct.price,
            'imgUrl': newproduct.imageUrl,
          }));
      _items[prodIndex] = newproduct;
      notifyListeners();
    } else {}
  }

  Future<void> deleteProductsinUser(String id) async {
    final url = Uri.https('ganesh-flutter-default-rtdb.firebaseio.com',
        '/products/$id.json?auth=$authToken');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could notdelete product');
    }
    existingProduct = null;
  }
}
