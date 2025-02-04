// lib/models/hotel.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Hotel {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String status;
  final int acceptMinutes;
  final int kitchenMinutes;
  final int deliveryMinutes;

  Hotel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.status,
    required this.acceptMinutes,
    required this.kitchenMinutes,
    required this.deliveryMinutes,
  });

  factory Hotel.fromMap(String id, Map<String, dynamic> data) {
    return Hotel(
      id: id,
      name: data['name'] ?? 'Unknown',
      address: data['address'] ?? 'Unknown',
      phone: data['phone'] ?? 'Unknown',
      status: data['status'] ?? 'Unknown',
      acceptMinutes: data['accept_minutes'] ?? 0,
      kitchenMinutes: data['kitchen_minutes'] ?? 0,
      deliveryMinutes: data['delivery_minutes'] ?? 0,
    );
  }

  // Add other methods or fields as necessary
}
