// lib/models/bill_order.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class BillOrder {
  final String documentId;
  final String hotelId;
  final String status;
  final DateTime timestamp; // Order creation time
  final DateTime? acceptTime; // New field for accept time
  final ShippingAddress shippingAddress;
  final List<CartItem> cartItems;
  final double total;
  final String paymentMethod;
  final String hotelName;
  final String? hotelIdRef; // Reference to hotel ID if needed

  BillOrder({
    required this.documentId,
    required this.hotelId,
    required this.status,
    required this.timestamp,
    this.acceptTime, // Initialize the new field
    required this.shippingAddress,
    required this.cartItems,
    required this.total,
    required this.paymentMethod,
    required this.hotelName,
    this.hotelIdRef,
  });

  factory BillOrder.fromMap(String documentId, Map<String, dynamic> data) {
    return BillOrder(
      documentId: documentId,
      hotelId: data['hotelId'] ?? '',
      status: data['status'] ?? 'pending',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      acceptTime: data['Accept_time'] != null
          ? (data['Accept_time'] as Timestamp).toDate()
          : null, // Parse Accept_time if available
      shippingAddress: ShippingAddress.fromMap(data['shippingAddress']),
      cartItems: (data['cartItems'] as List<dynamic>)
          .map((item) => CartItem.fromMap(item))
          .toList(),
      total: (data['total'] ?? 0).toDouble(),
      paymentMethod: data['paymentMethod'] ?? 'Unknown',
      hotelName: data['hotelName'] ?? 'Unknown',
      hotelIdRef: data['hotelIdRef'],
    );
  }

  // Add other methods or fields as necessary
}

class ShippingAddress {
  final String name;
  final String address;
  final String country;
  final String mobile;

  ShippingAddress({
    required this.name,
    required this.address,
    required this.country,
    required this.mobile,
  });

  factory ShippingAddress.fromMap(Map<String, dynamic> data) {
    return ShippingAddress(
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      country: data['country'] ?? '',
      mobile: data['mobile'] ?? '',
    );
  }

  // Add other methods or fields as necessary
}

class CartItem {
  final String dishName;
  final int quantity;
  final double price;

  CartItem({
    required this.dishName,
    required this.quantity,
    required this.price,
  });

  factory CartItem.fromMap(Map<String, dynamic> data) {
    return CartItem(
      dishName: data['dishName'] ?? '',
      quantity: data['quantity'] ?? 0,
      price: (data['price'] ?? 0).toDouble(),
    );
  }

  // Add other methods or fields as necessary
}
