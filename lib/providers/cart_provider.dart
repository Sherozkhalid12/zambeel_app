import 'package:flutter/foundation.dart';
import '../models/cart.dart';
import '../models/product.dart';
import '../services/firebase_service.dart';

class CartProvider with ChangeNotifier {
  Cart _cart = Cart();
  bool _isLoading = false;

  Cart get cart => _cart;
  bool get isLoading => _isLoading;

  CartProvider() {
    _loadCartFromFirestore();
  }

  void _loadCartFromFirestore() {
    FirebaseService.getCartFromFirestore().listen((cart) {
      _cart = cart;
      notifyListeners();
    });
  }

  void addItem(Product product, {String? color, String? size}) async {
    final existingIndex = _cart.items.indexWhere(
      (item) => item.product.id == product.id &&
          item.selectedColor == color &&
          item.selectedSize == size,
    );

    List<CartItem> newItems = List.from(_cart.items);

    if (existingIndex >= 0) {
      newItems[existingIndex] = CartItem(
        product: newItems[existingIndex].product,
        quantity: newItems[existingIndex].quantity + 1,
        selectedColor: newItems[existingIndex].selectedColor,
        selectedSize: newItems[existingIndex].selectedSize,
      );
    } else {
      newItems.add(CartItem(
        product: product,
        quantity: 1,
        selectedColor: color,
        selectedSize: size,
      ));
    }

    _cart = Cart(items: newItems);
    notifyListeners();
    
    // Save to Firestore
    await FirebaseService.saveCartToFirestore(_cart);
  }

  void removeItem(String productId, {String? color, String? size}) async {
    List<CartItem> newItems = _cart.items.where(
      (item) => !(item.product.id == productId &&
          item.selectedColor == color &&
          item.selectedSize == size),
    ).toList();
    
    _cart = Cart(items: newItems);
    notifyListeners();
    
    // Save to Firestore
    await FirebaseService.saveCartToFirestore(_cart);
  }

  void updateQuantity(String productId, int quantity, {String? color, String? size}) async {
    final index = _cart.items.indexWhere(
      (item) => item.product.id == productId &&
          item.selectedColor == color &&
          item.selectedSize == size,
    );

    if (index >= 0) {
      List<CartItem> newItems = List.from(_cart.items);
      
      if (quantity <= 0) {
        newItems.removeAt(index);
      } else {
        newItems[index] = CartItem(
          product: newItems[index].product,
          quantity: quantity,
          selectedColor: newItems[index].selectedColor,
          selectedSize: newItems[index].selectedSize,
        );
      }
      
      _cart = Cart(items: newItems);
      notifyListeners();
      
      // Save to Firestore
      await FirebaseService.saveCartToFirestore(_cart);
    }
  }

  void clear() async {
    _cart = Cart();
    notifyListeners();
    
    // Save to Firestore
    await FirebaseService.saveCartToFirestore(_cart);
  }

  double get totalAmount => _cart.totalAmount;
  int get itemCount => _cart.itemCount;
  bool get isEmpty => _cart.isEmpty;
} 