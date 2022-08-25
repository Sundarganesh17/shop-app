import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/auth.dart';
import 'package:flutter_complete_guide/provider/cart.dart';
import 'package:flutter_complete_guide/screens/product_detail_screen.dart';
import '../provider/product.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  //final String title;
  //final String imgUrl;
  //ProductItem(this.id, this.title, this.imgUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final Carts = Provider.of<Cart>(context);
    final authdata = Provider.of<Auth>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
        },
        child: Hero(
          tag: product.id,
          child: GridTile(
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
            footer: GridTileBar(
              leading: Consumer<Product>(
                builder: (ctx, product, _) => IconButton(
                  onPressed: () {
                    product.toggleFavouriteStatus(
                        authdata.token, authdata.userId);
                  },
                  icon: Icon(product.isFavourite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: Theme.of(context).accentColor,
                ),
              ),
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.black87,
              trailing: IconButton(
                onPressed: () {
                  Carts.addItem(product.id, product.title, product.price);
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('added item you orders'),
                      duration: Duration(seconds: 4),
                      action: SnackBarAction(
                          label: 'undo',
                          onPressed: () {
                            Carts.removesingleItem(product.id);
                          }),
                    ),
                  );
                },
                icon: Icon(Icons.shopping_cart),
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
