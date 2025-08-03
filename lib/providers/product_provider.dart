import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/firebase_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;

  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  ProductProvider() {
    _loadProducts();
  }

  void _loadProducts() {
    _isLoading = true;
    notifyListeners();

    FirebaseService.getProducts().listen((products) {
      _products = products;
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    });
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void searchProducts(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredProducts = _products.where((product) {
      bool categoryMatch = _selectedCategory == 'All' || product.category == _selectedCategory;
      bool searchMatch = _searchQuery.isEmpty || 
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.brand.toLowerCase().contains(_searchQuery.toLowerCase());
      return categoryMatch && searchMatch;
    }).toList();
    notifyListeners();
  }

  List<String> get categories {
    Set<String> categories = {'All'};
    for (var product in _products) {
      categories.add(product.category);
    }
    return categories.toList();
  }

  Future<Product?> getProductById(String id) async {
    try {
      return await FirebaseService.getProductById(id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      return await FirebaseService.getProductsByCategory(category);
    } catch (e) {
      return [];
    }
  }
} 