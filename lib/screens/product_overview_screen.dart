import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/products.dart';
import 'package:flutter_complete_guide/widgets/drawer.dart';
import '../provider/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';
import 'package:provider/provider.dart';

import '../widgets/product_gird.dart';

enum FilltersControl { Favourites, All }

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/productOverviewScreen';
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyfavourities = false;
  var _initState = false;
  var isloading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initState) {
      setState(() {
        isloading = true;
      });

      Provider.of<Products>(context).fetchandSetData().then((_) {
        setState(() {
          isloading = false;
        });
      });
    }
    _initState = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Myshop'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilltersControl selectedValue) {
              setState(() {
                if (selectedValue == FilltersControl.Favourites) {
                  _showOnlyfavourities = true;
                } else
                  () {
                    _showOnlyfavourities = false;
                  };
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('only favourites'),
                value: FilltersControl.Favourites,
              ),
              PopupMenuItem(
                child: Text('show all'),
                value: FilltersControl.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.NameRoute);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGird(_showOnlyfavourities),
    );
  }
}
