import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/products.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  //ProductDetailScreen(this.title);
  static const routeName = '/Product-detail-screen';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final LoadedData = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(LoadedData.title),
              background: Hero(
                  tag: LoadedData.id,
                  child: Image.network(LoadedData.imageUrl)),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(width: 10),
            Text(
              LoadedData.price.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.lightGreen,
                fontSize: 30,
              ),
            ),
            Text(
              LoadedData.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).textTheme.bodyText1.color),
            )
          ]))
        ],
      ),
    );
  }
}
