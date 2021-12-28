import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool oldStatus) {
    isFavorite = oldStatus;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://flutter-test-f2ad4-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');

    var jsonProduct = json.encode({'isFavorite': isFavorite});
    try {
      final response = await http.patch(url, body: jsonProduct);
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (err) {
      _setFavValue(oldStatus);
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'isFavorite': isFavorite,
      };
}
