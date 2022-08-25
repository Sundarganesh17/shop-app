import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/products.dart';
import 'package:provider/provider.dart';

import './product_item.dart';

class ProductGird extends StatelessWidget {
  final bool showFavs;
  ProductGird(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<Products>(context);
    final products =
        showFavs ? providerData.Favouriteitems : providerData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(
            // products[i].id, products[i].title, products[i].imageUrl),
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 3 / 2,
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
