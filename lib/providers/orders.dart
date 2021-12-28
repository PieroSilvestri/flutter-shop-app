import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    var url = Uri.parse(
        'https://flutter-test-f2ad4-default-rtdb.europe-west1.firebasedatabase.app/orders.json');
    _orders = [];
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData.isEmpty){
        return;
      }
      final List<OrderItem> loadedOrders = [];
      extractedData.forEach((ordId, ordData) {
        loadedOrders.add(OrderItem(
            id: ordId,
            amount: ordData['amount'],
            dateTime: DateTime.parse(ordData['dateTime']),
            products: (ordData['products'] as List<dynamic>)
                .map(
                  (e) => CartItem(
                    id: e['id'],
                    price: e['price'],
                    quantity: e['quantity'],
                    title: e['title'],
                  ),
                )
                .toList()));
      });
      _orders = loadedOrders;
      notifyListeners();
      //print(json.decode(response.body));
    } catch (error) {
      notifyListeners();
    }
  }

  Future<void> addOrder(List<CartItem> cartproducts, double total) async {
    var url = Uri.parse(
        'https://flutter-test-f2ad4-default-rtdb.europe-west1.firebasedatabase.app/orders.json');

    final modDateTime = DateTime.now();

    var jsonOrders = json.encode({
      'amount': total,
      'products': cartproducts
          .map((e) => {
                'id': e.id,
                'title': e.title,
                'quantity': e.quantity,
                'price': e.price
              })
          .toList(),
      'dateTime': modDateTime.toIso8601String(),
    });

    try {
      final response = await http.post(url, body: jsonOrders);
      final newProduct = OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartproducts,
        dateTime: modDateTime,
      );

      _orders.insert(0, newProduct);
      // Insert at the start of the list
      // _items.insert(0, newProduct);
      notifyListeners();
    } catch (err) {
      rethrow;
    }

    /*
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        products: cartproducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
    */
  }
}
