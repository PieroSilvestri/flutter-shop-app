import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;

  late Future _ordersFuture;

    Future _obtainOrdersFuture() {
      return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
    }

  @override
  void initState() {
    /*
    _isLoading = true;
    Provider.of<Orders>(context, listen: false)
        .fetchAndSetOrders()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    */
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final ordersData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (dataSnapshot.error != null) {
            return const Center(child: Text('An error occurred!'),);
          }
          return Consumer<Orders>(
            builder: (ctx, ordersData, child) => ListView.builder(
                itemCount: ordersData.orders.length,
                itemBuilder: (ctx, i) => OrderItem(ordersData.orders[i])),
          );
        },
      ),
    );
  }
}

class OrdersBuilder extends StatelessWidget {
  final Orders ordersData;

  const OrdersBuilder({
    Key? key,
    required this.ordersData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (ordersData.orders.isEmpty
        ? const Center(
            child: Text('There are no orders'),
          )
        : ListView.builder(
            itemCount: ordersData.orders.length,
            itemBuilder: (ctx, i) => OrderItem(ordersData.orders[i]),
          ));
  }
}
