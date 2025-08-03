import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final List<String> features;
  final double rating;
  final int reviewCount;
  final bool inStock;
  final String brand;
  final Map<String, dynamic> specifications;
  final List<String> colors;
  final List<String> sizes;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.features,
    required this.rating,
    required this.reviewCount,
    required this.inStock,
    required this.brand,
    required this.specifications,
    required this.colors,
    required this.sizes,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      category: json['category'],
      features: List<String>.from(json['features']),
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
      inStock: json['inStock'],
      brand: json['brand'],
      specifications: Map<String, dynamic>.from(json['specifications']),
      colors: List<String>.from(json['colors']),
      sizes: List<String>.from(json['sizes']),
    );
  }

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
      features: List<String>.from(data['features'] ?? []),
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      inStock: data['inStock'] ?? true,
      brand: data['brand'] ?? '',
      specifications: Map<String, dynamic>.from(data['specifications'] ?? {}),
      colors: List<String>.from(data['colors'] ?? []),
      sizes: List<String>.from(data['sizes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'features': features,
      'rating': rating,
      'reviewCount': reviewCount,
      'inStock': inStock,
      'brand': brand,
      'specifications': specifications,
      'colors': colors,
      'sizes': sizes,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'features': features,
      'rating': rating,
      'reviewCount': reviewCount,
      'inStock': inStock,
      'brand': brand,
      'specifications': specifications,
      'colors': colors,
      'sizes': sizes,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
} 