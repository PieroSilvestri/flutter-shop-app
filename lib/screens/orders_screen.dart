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

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero).then((value) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: _isLoading ? CircularProgressIndicator() : OrdersBuilder(ordersData: ordersData,)
    );
  }
}

class OrdersBuilder extends StatelessWidget {

  final Orders ordersData;

  const OrdersBuilder({
    Key? key, required this.ordersData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (ordersData.orders.isEmpty
          ? const Center(child: Text('There are no orders'),)
          : ListView.builder(
              itemCount: ordersData.orders.length,
              itemBuilder: (ctx, i) => OrderItem(ordersData.orders[i]),
            ));
  }
}
