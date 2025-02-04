// // lib/home/DetailsPage/bill_orders_widget.dart

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ez8liveorder/models/bill_order.dart';
// import 'package:audioplayers/audioplayers.dart'; // Import audioplayers
// import 'package:ez8liveorder/home/DetailsPage/time/countdown_timer_widget.dart'; // Import CountdownTimerWidget
// import 'package:ez8liveorder/home/translations/translations.dart';

// class BillOrdersWidget extends StatefulWidget {
//   final String hotelId;
//   final int acceptMinutes;
//   final int kitchenMinutes;
//   final int deliveryMinutes;
//   final Function(BillOrder) onOrderSelected;

//   BillOrdersWidget({
//     required this.hotelId,
//     required this.acceptMinutes,
//     required this.kitchenMinutes,
//     required this.deliveryMinutes,
//     required this.onOrderSelected,
//   });

//   @override
//   _BillOrdersWidgetState createState() => _BillOrdersWidgetState();
// }

// class _BillOrdersWidgetState extends State<BillOrdersWidget> {
//   // Audio player instance
//   final AudioPlayer _audioPlayer = AudioPlayer();

//   // Keep track of previous 'Order New' orders
//   List<BillOrder> _previousOrderNew = [];

//   @override
//   void dispose() {
//     _audioPlayer.dispose(); // Dispose the audio player
//     super.dispose();
//   }

//   /// Group orders into the five categories: Order New, Kitchen, On the way,
//   /// Delivered, and Cancal.
//   Map<String, List<BillOrder>> _groupOrdersByStatus(List<BillOrder> orders) {
//     Map<String, List<BillOrder>> groupedOrders = {
//       'Order New': [],
//       'Kitchen': [],
//       'On the way': [],
//       'Delivered': [],
//       'Cancal': [],
//     };

//     for (var order in orders) {
//       switch (order.status.toLowerCase()) {
//         case 'pending':
//           groupedOrders['Order New']!.add(order);
//           break;
//         case 'kitchen':
//           groupedOrders['Kitchen']!.add(order);
//           break;
//         case 'ready':
//           groupedOrders['On the way']!.add(order);
//           break;
//         case 'delivered':
//           groupedOrders['Delivered']!.add(order);
//           break;
//         case 'cancal': // Make sure the order status matches exactly what you expect.
//           groupedOrders['Cancal']!.add(order);
//           break;
//         default:
//           // You can optionally handle other statuses here.
//           break;
//       }
//     }

//     return groupedOrders;
//   }

//   // Method to play sound when new orders arrive
//   Future<void> _playSound() async {
//     try {
//       // Make sure the file exists in assets and is declared in pubspec.yaml
//       await _audioPlayer.play(AssetSource('assets/img/sound.mp3'));
//     } catch (e) {
//       print('Error playing sound: $e');
//     }
//   }

//   // Method to accept an order (update status from 'pending' to 'kitchen' and set Accept_time)
//   Future<void> _acceptOrder(BillOrder order) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('BillOrder')
//           .doc(order.documentId)
//           .update({
//         'status': 'kitchen',
//         'Accept_time': FieldValue.serverTimestamp(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             '${Translations.text("orderAcceptedSuccess")} ${order.documentId}',
//           ),
//         ),
//       );
//     } catch (e) {
//       print('Error accepting order: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(Translations.text('orderAcceptFailed')),
//         ),
//       );
//     }
//   }

//   /// Optional: Method to accept all 'pending' orders at once
//   Future<void> _acceptAllOrders(List<BillOrder> orders) async {
//     try {
//       WriteBatch batch = FirebaseFirestore.instance.batch();

//       for (var order in orders) {
//         DocumentReference orderRef = FirebaseFirestore.instance
//             .collection('BillOrder')
//             .doc(order.documentId);
//         batch.update(orderRef, {
//           'status': 'kitchen',
//           'Accept_time': FieldValue.serverTimestamp(),
//         });
//       }

//       await batch.commit();

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(Translations.text('allOrdersAccepted'))),
//       );
//     } catch (e) {
//       print('Error accepting all orders: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(Translations.text('acceptAllFailed'))),
//       );
//     }
//   }

//   /// Calculate the target time for an order based on its status.
//   DateTime _calculateTargetTime(BillOrder order) {
//     switch (order.status.toLowerCase()) {
//       case 'pending':
//       case 'order new':
//         return order.timestamp.add(Duration(minutes: widget.acceptMinutes));
//       case 'kitchen':
//         if (order.acceptTime != null) {
//           return order.acceptTime!
//               .add(Duration(minutes: widget.kitchenMinutes));
//         } else {
//           return order.timestamp.add(Duration(minutes: widget.acceptMinutes));
//         }
//       case 'ready':
//         if (order.acceptTime != null) {
//           return order.acceptTime!
//               .add(Duration(minutes: widget.deliveryMinutes));
//         } else {
//           return order.timestamp.add(Duration(minutes: widget.acceptMinutes));
//         }
//       default:
//         return order.timestamp.add(Duration(minutes: widget.acceptMinutes));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Stream to listen to BillOrder collection
//     Stream<QuerySnapshot> billOrdersStream = FirebaseFirestore.instance
//         .collection('BillOrder')
//         .where('hotelId', isEqualTo: widget.hotelId)
//         .snapshots();

//     return StreamBuilder<QuerySnapshot>(
//       stream: billOrdersStream,
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           print('Snapshot error: ${snapshot.error}');
//           return Center(
//             child: Text(
//               Translations.text('errorLoadingBillOrders'),
//               style: TextStyle(fontSize: 16, color: Colors.red),
//             ),
//           );
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }

//         // Convert QuerySnapshot to List<BillOrder>
//         List<BillOrder> billOrders = snapshot.data!.docs
//             .map((doc) =>
//                 BillOrder.fromMap(doc.id, doc.data() as Map<String, dynamic>))
//             .toList();

//         // Group orders by status
//         final groupedOrders = _groupOrdersByStatus(billOrders);

//         // Detect new orders in 'Order New'
//         List<BillOrder> currentOrderNew = groupedOrders['Order New']!;
//         if (_previousOrderNew.isNotEmpty &&
//             currentOrderNew.length > _previousOrderNew.length) {
//           _playSound();
//         }
//         // Update previous orders
//         _previousOrderNew = List.from(currentOrderNew);

//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: groupedOrders.entries.map((entry) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Heading for each status group with optional 'Accept All' button for new orders
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         entry.key,
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blueAccent,
//                         ),
//                       ),
//                       if (entry.key == 'Order New' && entry.value.isNotEmpty)
//                         ElevatedButton(
//                           onPressed: () {
//                             _acceptAllOrders(entry.value);
//                           },
//                           child: Text(Translations.text('acceptAll')),
//                         ),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   entry.value.isNotEmpty
//                       ? ListView.builder(
//                           physics: NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           itemCount: entry.value.length,
//                           itemBuilder: (context, index) {
//                             final order = entry.value[index];
//                             return Card(
//                               elevation: 3,
//                               margin: EdgeInsets.symmetric(vertical: 6),
//                               child: ListTile(
//                                 leading: Icon(Icons.receipt_long,
//                                     color: Colors.blue),
//                                 title: Text(
//                                   '${Translations.text("orderId")} ${order.documentId}',
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 subtitle: Text(
//                                   '${Translations.text("customer")}: ${order.shippingAddress.name}',
//                                   style: TextStyle(color: Colors.grey[600]),
//                                 ),
//                                 trailing: _buildTrailingWidget(order),
//                                 onTap: () {
//                                   widget.onOrderSelected(order);
//                                 },
//                               ),
//                             );
//                           },
//                         )
//                       : Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 8.0, horizontal: 16.0),
//                           child: Text(
//                             Translations.text('noOrdersInCategory'),
//                             style: TextStyle(
//                                 fontSize: 14, color: Colors.grey[700]),
//                           ),
//                         ),
//                   SizedBox(height: 16),
//                 ],
//               );
//             }).toList(),
//           ),
//         );
//       },
//     );
//   }

//   /// Builds the trailing widget based on the order's status.
//   Widget? _buildTrailingWidget(BillOrder order) {
//     if (order.status.toLowerCase() == 'pending' ||
//         order.status.toLowerCase() == 'order new') {
//       final targetTime = _calculateTargetTime(order);
//       return Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               _acceptOrder(order);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//             ),
//             child: Text(Translations.text('accept')),
//           ),
//           SizedBox(width: 8),
//           CountdownTimerWidget(
//             targetTime: targetTime,
//             onCountdownComplete: () {
//               // Show a snackbar if the countdown completes.
//               // Do NOT update the order status to "expired", even if the time has passed.
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(
//                     '${Translations.text("acceptTimeExpiredFor")} ${order.documentId}',
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       );
//     } else if (order.status.toLowerCase() == 'kitchen' ||
//         order.status.toLowerCase() == 'ready') {
//       if (order.acceptTime == null) {
//         return Text(
//           Translations.text('acceptTimeNotSet'),
//           style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//         );
//       }
//       final targetTime = _calculateTargetTime(order);
//       return CountdownTimerWidget(
//         targetTime: targetTime,
//         onCountdownComplete: () {
//           // Just notify the user that processing time has expired.
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 '${Translations.text("processingTimeExpiredFor")} ${order.documentId}',
//               ),
//             ),
//           );
//           // Note: We no longer update the order status to "expired" automatically.
//           // If you want to handle expiration in a different way, you can do so here.
//         },
//       );
//     } else {
//       // For other statuses (e.g., Delivered, Cancal) no trailing widget is required.
//       return null;
//     }
//   }
// }
