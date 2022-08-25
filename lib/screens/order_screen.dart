import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/order.dart';
import 'package:flutter_complete_guide/widgets/drawer.dart';
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/OrderScreen';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future _olderFuture;
  Future _obtainOrderFuture() {
    return Provider.of<Order>(context, listen: false).FetchSetdata();
  }

  @override
  void initState() {
    // TODO: implement initState
    _olderFuture = _obtainOrderFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  final orderscreenData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'your orders here',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _olderFuture,
        builder: (ctx, Datasnapshot) {
          if (Datasnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (Datasnapshot.error != null) {
              return Center(
                child: Text('error detected'),
              );
            } else {
              return Consumer<Order>(
                builder: (context, orderscreenData, child) => ListView.builder(
                  itemCount: orderscreenData.order.length,
                  itemBuilder: (ctx, i) => OrderItems(orderscreenData.order[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
