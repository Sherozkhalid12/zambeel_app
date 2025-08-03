import 'package:cloud_firestore/cloud_firestore.dart';
import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  String? selectedColor;
  String? selectedSize;

  CartItem({
    required this.product,
    required this.quantity,
    this.selectedColor,
    this.selectedSize,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'selectedColor': selectedColor,
      'selectedSize': selectedSize,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'productId': product.id,
      'productName': product.name,
      'productPrice': product.price,
      'productImage': product.imageUrl,
      'productBrand': product.brand,
      'quantity': quantity,
      'selectedColor': selectedColor,
      'selectedSize': selectedSize,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      selectedColor: json['selectedColor'],
      selectedSize: json['selectedSize'],
    );
  }

  factory CartItem.fromFirestore(Map<String, dynamic> data) {
    return CartItem(
      product: Product(
        id: data['productId'] ?? '',
        name: data['productName'] ?? '',
        description: '',
        price: (data['productPrice'] ?? 0.0).toDouble(),
        imageUrl: data['productImage'] ?? '',
        category: '',
        features: [],
        rating: 0.0,
        reviewCount: 0,
        inStock: true,
        brand: data['productBrand'] ?? '',
        specifications: {},
        colors: [],
        sizes: [],
      ),
      quantity: data['quantity'] ?? 1,
      selectedColor: data['selectedColor'],
      selectedSize: data['selectedSize'],
    );
  }
}

class Cart {
  final List<CartItem> items;

  Cart({this.items = const []});

  double get totalAmount {
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  bool get isEmpty => items.isEmpty;

  Cart copyWith({
    List<CartItem>? items,
  }) {
    return Cart(
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'items': items.map((item) => item.toFirestore()).toList(),
      'totalAmount': totalAmount,
      'itemCount': itemCount,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
    );
  }

  factory Cart.fromFirestore(Map<String, dynamic> data) {
    List<CartItem> items = [];
    if (data['items'] != null) {
      items = (data['items'] as List)
          .map((item) => CartItem.fromFirestore(item))
          .toList();
    }
    return Cart(items: items);
  }
} 