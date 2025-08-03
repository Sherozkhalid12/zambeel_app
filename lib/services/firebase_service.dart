import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/product.dart';
import '../models/cart.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Authentication Methods
  static User? get currentUser => _auth.currentUser;

  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  static Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      print('Starting signup for email: $email'); // Debug print
      
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      print('User created successfully: ${result.user?.uid}'); // Debug print
      
      // Create user profile in Firestore
      try {
        await _firestore.collection('users').doc(result.user!.uid).set({
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'phone': '',
          'address': '',
        });
      } catch (firestoreError) {
        print('Firestore error: $firestoreError'); // Debug print
        // If Firestore fails, we should still allow the user to be created
        // but we'll rethrow the error for now to see what's happening
        rethrow;
      }
      
      print('User profile created in Firestore'); // Debug print
      return result;
    } catch (e) {
      print('Signup error: $e'); // Debug print
      rethrow;
    }
  }

  static Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // User Profile Methods
  static Future<void> updateUserProfile({
    required String name,
    required String phone,
    required String address,
  }) async {
    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser!.uid).update({
        'name': name,
        'phone': phone,
        'address': address,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  static Future<Map<String, dynamic>?> getUserProfile() async {
    if (currentUser != null) {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get();
      return doc.data() as Map<String, dynamic>?;
    }
    return null;
  }

  // Product Methods
  static Stream<List<Product>> getProducts() {
    return _firestore
        .collection('products')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromFirestore(doc))
            .toList());
  }

  static Future<List<Product>> getProductsByCategory(String category) async {
    QuerySnapshot snapshot = await _firestore
        .collection('products')
        .where('category', isEqualTo: category)
        .get();
    
    return snapshot.docs
        .map((doc) => Product.fromFirestore(doc))
        .toList();
  }

  static Future<Product?> getProductById(String id) async {
    DocumentSnapshot doc = await _firestore
        .collection('products')
        .doc(id)
        .get();
    
    if (doc.exists) {
      return Product.fromFirestore(doc);
    }
    return null;
  }

  // Cart Methods
  static Future<void> saveCartToFirestore(Cart cart) async {
    if (currentUser != null) {
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('cart')
          .doc('current')
          .set(cart.toFirestore());
    }
  }

  static Stream<Cart> getCartFromFirestore() {
    if (currentUser != null) {
      return _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('cart')
          .doc('current')
          .snapshots()
          .map((doc) {
        if (doc.exists && doc.data() != null) {
          return Cart.fromFirestore(doc.data()!);
        }
        return Cart();
      });
    }
    return Stream.value(Cart());
  }

  // Order Methods
  static Future<String> createOrder({
    required List<CartItem> items,
    required double totalAmount,
    required String shippingAddress,
    required String paymentMethod,
  }) async {
    if (currentUser != null) {
      DocumentReference orderRef = await _firestore
          .collection('orders')
          .add({
        'userId': currentUser!.uid,
        'items': items.map((item) => item.toFirestore()).toList(),
        'totalAmount': totalAmount,
        'shippingAddress': shippingAddress,
        'paymentMethod': paymentMethod,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      return orderRef.id;
    }
    throw Exception('User not authenticated');
  }

  static Stream<List<Map<String, dynamic>>> getUserOrders() {
    if (currentUser != null) {
      return _firestore
          .collection('orders')
          .where('userId', isEqualTo: currentUser!.uid)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => {
                    'id': doc.id,
                    ...doc.data() as Map<String, dynamic>,
                  })
              .toList());
    }
    return Stream.value([]);
  }

  // Wishlist Methods
  static Future<void> addToWishlist(String productId) async {
    if (currentUser != null) {
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('wishlist')
          .doc(productId)
          .set({
        'productId': productId,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  static Future<void> removeFromWishlist(String productId) async {
    if (currentUser != null) {
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('wishlist')
          .doc(productId)
          .delete();
    }
  }

  static Stream<List<String>> getWishlist() {
    if (currentUser != null) {
      return _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('wishlist')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => doc.id)
              .toList());
    }
    return Stream.value([]);
  }

  // Review Methods
  static Future<void> addReview({
    required String productId,
    required double rating,
    required String comment,
  }) async {
    if (currentUser != null) {
      await _firestore
          .collection('products')
          .doc(productId)
          .collection('reviews')
          .add({
        'userId': currentUser!.uid,
        'userName': currentUser!.displayName ?? 'Anonymous',
        'rating': rating,
        'comment': comment,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  static Stream<List<Map<String, dynamic>>> getProductReviews(String productId) {
    return _firestore
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc.data() as Map<String, dynamic>,
                })
            .toList());
  }

  // Storage Methods
  static Future<String> uploadImage(File file, String path) async {
    Reference ref = _storage.ref().child(path);
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  static Future<void> deleteImage(String url) async {
    Reference ref = _storage.refFromURL(url);
    await ref.delete();
  }
} 