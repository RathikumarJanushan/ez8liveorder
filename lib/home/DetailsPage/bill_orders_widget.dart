// lib/home/DetailsPage/bill_orders_widget.dart

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez8liveorder/models/bill_order.dart';
import 'package:ez8liveorder/home/translations/translations.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // for loading the logo
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

// PDF & printing
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class BillOrdersWidget extends StatefulWidget {
  /// Pass the current hotel's id to filter orders
  final String hotelId;
  const BillOrdersWidget({Key? key, required this.hotelId}) : super(key: key);

  @override
  _BillOrdersWidgetState createState() => _BillOrdersWidgetState();
}

class _BillOrdersWidgetState extends State<BillOrdersWidget> {
  BillOrder? selectedOrder;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Keep track of previously seen "Order New" orders to play sound on new ones
  List<BillOrder> _previousOrderNew = [];

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  /// Group orders by their status.
  Map<String, List<BillOrder>> _groupOrdersByStatus(List<BillOrder> orders) {
    final grouped = <String, List<BillOrder>>{
      'Order New': [],
      'Kitchen': [],
      'On the way': [],
      'Delivered': [],
      'Cancal': [],
    };

    for (final order in orders) {
      switch (order.status.toLowerCase()) {
        case 'pending':
          grouped['Order New']!.add(order);
          break;
        case 'kitchen':
          grouped['Kitchen']!.add(order);
          break;
        case 'ready':
          grouped['On the way']!.add(order);
          break;
        case 'delivered':
          grouped['Delivered']!.add(order);
          break;
        case 'cancal':
          grouped['Cancal']!.add(order);
          break;
        default:
          // Other statuses if any
          break;
      }
    }
    return grouped;
  }

  /// Play a sound when new orders arrive.
  Future<void> _playSound() async {
    try {
      await _audioPlayer.play(AssetSource('assets/img/sound.mp3'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  /// Accept a single order.
  Future<void> _acceptOrder(BillOrder order) async {
    try {
      await FirebaseFirestore.instance
          .collection('BillOrder')
          .doc(order.documentId)
          .update({
        'status': 'kitchen',
        'Accept_time': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${Translations.text("orderAcceptedSuccess")} ${order.documentId}',
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error accepting order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Translations.text('orderAcceptFailed'))),
      );
    }
  }

  /// Accept all pending orders.
  Future<void> _acceptAllOrders(List<BillOrder> orders) async {
    try {
      final batch = FirebaseFirestore.instance.batch();

      for (final order in orders) {
        final ref = FirebaseFirestore.instance
            .collection('BillOrder')
            .doc(order.documentId);
        batch.update(ref, {
          'status': 'kitchen',
          'Accept_time': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Translations.text('allOrdersAccepted'))),
      );
    } catch (e) {
      debugPrint('Error accepting all orders: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Translations.text('acceptAllFailed'))),
      );
    }
  }

  /// Set the selected order to display its details.
  void _onOrderSelected(BillOrder order) {
    setState(() {
      selectedOrder = order;
    });
  }

  //----------------------------------------------------------------------------
  //  BUILD THE PDF (2-INCH WIDE) WITH SINGLE "SCAN ORDER ID"
  //----------------------------------------------------------------------------
  Future<Uint8List> _buildPdf(BillOrder order, DateTime deliveryTime) async {
    final pdf = pw.Document();

    // 1) LOAD THE LOGO
    final logoBytes = await rootBundle.load('assets/img/quickrunez8.jpg');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

    // 2) SET 2-INCH WIDTH, smaller height (~700 points) to avoid extra blank space
    final pageFormat = PdfPageFormat(
      2 * PdfPageFormat.inch, // 2 inches wide
      700, // reduce height to ~9.7 inches
      marginAll: 5, // small margin
    );

    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // -- LOGO --
              pw.Center(
                child: pw.Image(logoImage, width: 80, height: 80),
              ),
              pw.SizedBox(height: 5),

              // eZ8
              pw.Center(
                child: pw.Text('eZ8',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    )),
              ),
              // Quickrun GmbH
              pw.Center(
                child: pw.Text(
                  'Quickrun GmbH',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
              pw.SizedBox(height: 5),

              // Hotel Name
              pw.Text(
                'Hotel Name: ${order.hotelName}',
                style: const pw.TextStyle(fontSize: 10),
              ),
              // Order ID:
              pw.Text(
                'Order ID:: ${order.documentId}',
                style: const pw.TextStyle(fontSize: 10),
              ),
              // Timestamp
              pw.Text(
                'Timestamp: ${DateFormat("yyyy-MM-dd HH:mm").format(order.timestamp)}',
                style: const pw.TextStyle(fontSize: 10),
              ),
              // Dotted line
              pw.Text('..................................',
                  style: const pw.TextStyle(fontSize: 10)),

              // Deliver Time
              pw.Text(
                'deliver Time: ${DateFormat("yyyy-MM-dd HH:mm").format(deliveryTime)}',
                style: const pw.TextStyle(fontSize: 10),
              ),
              // Customer
              pw.Text(
                'customer: ${order.shippingAddress.name}',
                style: const pw.TextStyle(fontSize: 10),
              ),
              // Shipping Address
              pw.Text(
                'Shipping Address:: ${order.shippingAddress.address}, '
                '${order.shippingAddress.country}',
                style: const pw.TextStyle(fontSize: 10),
              ),
              // Dotted line
              pw.Text('..................................',
                  style: const pw.TextStyle(fontSize: 10)),

              // Cart Items
              pw.Text(
                'cart items::',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
              ),
              ...order.cartItems.map((item) {
                return pw.Text(
                  '${item.dishName} x${item.quantity}  CHF ${item.price.toStringAsFixed(2)}',
                  style: const pw.TextStyle(fontSize: 9),
                );
              }).toList(),
              // Dotted line
              pw.Text('..................................',
                  style: const pw.TextStyle(fontSize: 10)),

              // Total
              pw.Text(
                'Total: CHF ${order.total.toStringAsFixed(2)}',
                style: const pw.TextStyle(fontSize: 10),
              ),
              // Payment Method
              pw.Text(
                'Payment Method: ${order.paymentMethod}',
                style: const pw.TextStyle(fontSize: 10),
              ),
              // Dotted line
              pw.Text('..................................',
                  style: const pw.TextStyle(fontSize: 10)),

              // SCAN ORDER ID
              pw.Text(
                'Scan Order ID:',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
              ),
              // Dotted line
              pw.Text('..................................',
                  style: const pw.TextStyle(fontSize: 10)),

              // Single QR Code
              pw.Center(
                child: pw.BarcodeWidget(
                  data: order.documentId,
                  barcode: pw.Barcode.qrCode(),
                  width: 70,
                  height: 70,
                ),
              ),
              // Slight space at bottom (optional)
              pw.SizedBox(height: 8),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  //----------------------------------------------------------------------------
  //  SHOW ORDER DETAILS DIALOG (with Auto Print switch)
  //----------------------------------------------------------------------------
  void _showOrderDetailsDialog(BillOrder order) {
    // Initialize with DateTime.now() + 60 minutes
    DateTime computedDeliveryTime =
        DateTime.now().add(const Duration(minutes: 60));

    // For capturing the user’s input for how many minutes to add
    final TextEditingController deliveryController =
        TextEditingController(text: "60");

    // Auto-print toggle
    bool isAutoPrintOn = false;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Text('Order ID: ${order.documentId}'),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timestamps
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Show the original order timestamp
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order Placed: ${DateFormat("yyyy-MM-dd HH:mm").format(order.timestamp)}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Delivery Time: ${DateFormat("yyyy-MM-dd HH:mm").format(computedDeliveryTime)}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Let user specify how many minutes from "now"
                      const Text('Enter Delivery Minutes:',
                          style: TextStyle(fontSize: 14)),
                      TextField(
                        controller: deliveryController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final mins = int.tryParse(value) ?? 60;
                          setState(() {
                            // Always base on current time, not order.timestamp
                            computedDeliveryTime =
                                DateTime.now().add(Duration(minutes: mins));
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Basic Order details
                      Text('Hotel Name: ${order.hotelName}',
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('Customer: ${order.shippingAddress.name}',
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      const Text('Shipping Address:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(order.shippingAddress.address,
                          style: const TextStyle(fontSize: 14)),
                      Text(order.shippingAddress.country,
                          style: const TextStyle(fontSize: 14)),
                      Text('Mobile: ${order.shippingAddress.mobile}',
                          style: const TextStyle(fontSize: 14)),

                      const Divider(height: 20),

                      // Cart items
                      const Text('Cart Items:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...order.cartItems.map(
                        (item) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.fastfood,
                              color: Colors.orange, size: 20),
                          title: Text(item.dishName,
                              style: const TextStyle(fontSize: 14)),
                          subtitle: Text('Quantity: ${item.quantity}',
                              style: const TextStyle(fontSize: 12)),
                          trailing: Text(
                            'CHF ${item.price.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      const Divider(height: 20),

                      Text('Total: CHF ${order.total.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Payment Method: ${order.paymentMethod}',
                          style: const TextStyle(fontSize: 14)),

                      const Divider(height: 20),

                      // QR Code
                      const Text('Scan Order ID:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Center(
                        child: QrImageView(
                          data: order.documentId,
                          version: QrVersions.auto,
                          size: 100,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('Auto Print', style: TextStyle(fontSize: 14)),
                    Switch(
                      value: isAutoPrintOn,
                      onChanged: (val) {
                        setState(() {
                          isAutoPrintOn = val;
                        });
                      },
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final mins =
                            int.tryParse(deliveryController.text) ?? 60;
                        // Calculate final delivery time from NOW
                        final newDeliveryTime =
                            DateTime.now().add(Duration(minutes: mins));

                        try {
                          // Update Firestore with the new delivery time
                          await FirebaseFirestore.instance
                              .collection('BillOrder')
                              .doc(order.documentId)
                              .update({
                            'delivery_time': newDeliveryTime,
                          });

                          // Build the custom PDF for printing (2-inch wide)
                          final pdfBytes =
                              await _buildPdf(order, newDeliveryTime);

                          if (isAutoPrintOn) {
                            // Let user pick a printer, then direct print
                            final printer =
                                await Printing.pickPrinter(context: context);
                            if (printer == null) return; // user canceled
                            await Printing.directPrintPdf(
                              printer: printer,
                              name: 'Order_${order.documentId}',
                              format: PdfPageFormat(
                                2 * PdfPageFormat.inch,
                                700, // same as in _buildPdf
                                marginAll: 5,
                              ),
                              onLayout: (PdfPageFormat format) async =>
                                  pdfBytes,
                            );
                          } else {
                            // Show the print preview => user can also save as PDF
                            await Printing.layoutPdf(
                              name: 'Order_${order.documentId}',
                              format: PdfPageFormat(
                                2 * PdfPageFormat.inch,
                                700,
                                marginAll: 5,
                              ),
                              onLayout: (PdfPageFormat format) async =>
                                  pdfBytes,
                            );
                          }

                          Navigator.of(context).pop();
                        } catch (e) {
                          debugPrint('Error updating delivery time: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed updating delivery time'),
                            ),
                          );
                        }
                      },
                      child: const Text('Print'),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Build the list of orders (left column).
  Widget _buildOrdersList() {
    final ordersStream = FirebaseFirestore.instance
        .collection('BillOrder')
        .where('hotelId', isEqualTo: widget.hotelId)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: ordersStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading Bill Orders',
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final billOrders = snapshot.data!.docs
            .map((doc) => BillOrder.fromMap(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ))
            .toList();

        final grouped = _groupOrdersByStatus(billOrders);

        // Check for new "Order New" orders
        final newOrdersNow = grouped['Order New']!;
        if (_previousOrderNew.isNotEmpty &&
            newOrdersNow.length > _previousOrderNew.length) {
          _playSound();
        }
        _previousOrderNew = List.from(newOrdersNow);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: grouped.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      if (entry.key == 'Order New' && entry.value.isNotEmpty)
                        ElevatedButton(
                          onPressed: () => _acceptAllOrders(entry.value),
                          child: const Text('Accept All'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  entry.value.isNotEmpty
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: entry.value.length,
                          itemBuilder: (context, index) {
                            final order = entry.value[index];
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.receipt_long,
                                  color: Colors.blue,
                                ),
                                title: Text(
                                  'Order ID ${order.documentId}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'Customer: ${order.shippingAddress.name}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                onTap: () => _onOrderSelected(order),
                                trailing: _buildTrailing(order),
                              ),
                            );
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          child: Text(
                            'No orders in this category.',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                        ),
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget? _buildTrailing(BillOrder order) {
    if (order.status.toLowerCase() == 'pending' ||
        order.status.toLowerCase() == 'order new') {
      return ElevatedButton(
        onPressed: () => _acceptOrder(order),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        child: const Text('Accept'),
      );
    }
    return null;
  }

  /// Build the order details view (right column).
  Widget _buildOrderDetails() {
    if (selectedOrder == null) {
      return const Center(
        child: Text(
          'Please select an order',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    final order = selectedOrder!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID with print icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Order ID: ${order.documentId}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.print),
                onPressed: () => _showOrderDetailsDialog(order),
              ),
            ],
          ),
          // Timestamp
          Text(
            'Timestamp: ${DateFormat("yyyy-MM-dd HH:mm").format(order.timestamp)}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'Hotel Name: ${order.hotelName}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Customer: ${order.shippingAddress.name}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Shipping Address:',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(order.shippingAddress.address,
              style: const TextStyle(fontSize: 14)),
          Text(order.shippingAddress.country,
              style: const TextStyle(fontSize: 14)),
          Text('Mobile: ${order.shippingAddress.mobile}',
              style: const TextStyle(fontSize: 14)),
          const Divider(height: 20),
          Text(
            'Cart Items:',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...order.cartItems.map(
            (item) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading:
                  const Icon(Icons.fastfood, color: Colors.orange, size: 20),
              title: Text(item.dishName, style: const TextStyle(fontSize: 14)),
              subtitle: Text('Quantity: ${item.quantity}',
                  style: const TextStyle(fontSize: 12)),
              trailing: Text(
                'CHF ${item.price.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Divider(height: 20),
          Text(
            'Total: CHF ${order.total.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Payment Method: ${order.paymentMethod}',
            style: const TextStyle(fontSize: 16),
          ),
          const Divider(height: 20),
          Text(
            'Scan Order ID:',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Center(
            child: QrImageView(
              data: order.documentId,
              version: QrVersions.auto,
              size: 120,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left side: Orders List
        Expanded(
          flex: 2,
          child: _buildOrdersList(),
        ),
        // Right side: Order Details
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
            ),
            child: _buildOrderDetails(),
          ),
        ),
      ],
    );
  }
}
