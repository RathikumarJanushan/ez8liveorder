// // lib/home/DetailsPage/order_details_widget.dart

// import 'dart:typed_data';
// import 'package:flutter/material.dart';

// // Models
// import 'package:ez8liveorder/models/bill_order.dart';
// import 'package:ez8liveorder/models/hotel.dart';

// // Time display (countdown)
// import 'package:ez8liveorder/home/DetailsPage/time/countdown_timer_widget.dart';

// // Internationalization / date formatting
// import 'package:intl/intl.dart';

// // PDF and Printing
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// // QR libraries
// import 'package:qr_flutter/qr_flutter.dart' as qrFlutter;
// import 'package:qr/qr.dart' as pureQr; // raw QR library
// import 'package:ez8liveorder/home/translations/translations.dart';

// class OrderDetailsWidget extends StatelessWidget {
//   final BillOrder? order;
//   final Hotel? hotel;

//   const OrderDetailsWidget({Key? key, this.order, this.hotel})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (order == null) {
//       return Center(
//         child: Text(
//           Translations.text('selectOrderPlaceholder'),
//           style: TextStyle(fontSize: 18, color: Colors.grey),
//         ),
//       );
//     }

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(24.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Text(
//             Translations.text('orderDetailsHeader'),
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.blueAccent,
//             ),
//           ),
//           Divider(thickness: 2),
//           SizedBox(height: 16),

//           // Order ID
//           Text(
//             '${Translations.text("orderId")}: ${order!.documentId}',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 8),

//           // Customer
//           Text(
//             '${Translations.text("customer")}: ${order!.shippingAddress.name}',
//             style: TextStyle(fontSize: 16),
//           ),
//           SizedBox(height: 8),

//           // Status Chip
//           Chip(
//             label: Text(
//               order!.status.toUpperCase(),
//               style: TextStyle(color: Colors.white, fontSize: 14),
//             ),
//             backgroundColor: _getStatusColor(order!.status),
//           ),
//           SizedBox(height: 16),

//           // Additional info based on status
//           _buildAdditionalInfo(context),
//           SizedBox(height: 16),

//           // Cart Items
//           Text(
//             Translations.text('cartItemsLabel'),
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           ...order!.cartItems.map((item) {
//             return ListTile(
//               leading: Icon(Icons.fastfood, color: Colors.orange, size: 20),
//               title: Text(
//                 item.dishName,
//                 style: TextStyle(fontSize: 14),
//               ),
//               subtitle: Text(
//                 '${Translations.text("quantity")}: ${item.quantity}',
//                 style: TextStyle(fontSize: 12),
//               ),
//               trailing: Text(
//                 'CHF ${item.price.toStringAsFixed(2)}',
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//               ),
//             );
//           }).toList(),
//           Divider(),

//           // Shipping Address
//           Text(
//             Translations.text('shippingAddressLabel'),
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           ListTile(
//             leading: Icon(Icons.person, color: Colors.green, size: 20),
//             title: Text(
//               order!.shippingAddress.name,
//               style: TextStyle(fontSize: 14),
//             ),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   order!.shippingAddress.address,
//                   style: TextStyle(fontSize: 12),
//                 ),
//                 Text(
//                   order!.shippingAddress.country,
//                   style: TextStyle(fontSize: 12),
//                 ),
//                 Text(
//                   '${Translations.text("mobile")}: ${order!.shippingAddress.mobile}',
//                   style: TextStyle(fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//           Divider(),

//           // Additional Info
//           Text(
//             Translations.text('additionalInfoLabel'),
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           ListTile(
//             leading: Icon(Icons.attach_money, color: Colors.teal, size: 20),
//             title: Text(
//               Translations.text('total'),
//               style: TextStyle(fontSize: 14),
//             ),
//             subtitle: Text(
//               'CHF ${order!.total.toStringAsFixed(2)}',
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.payment, color: Colors.redAccent, size: 20),
//             title: Text(
//               Translations.text('paymentMethod'),
//               style: TextStyle(fontSize: 14),
//             ),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   order!.paymentMethod,
//                   style: TextStyle(fontSize: 14),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   Translations.text('scanOrderId'),
//                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 4),
//                 qrFlutter.QrImageView(
//                   data: order!.documentId,
//                   version: qrFlutter.QrVersions.auto,
//                   size: 150,
//                   gapless: false,
//                 ),
//               ],
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.hotel, color: Colors.redAccent, size: 20),
//             title: Text(
//               Translations.text('hotelName'),
//               style: TextStyle(fontSize: 14),
//             ),
//             subtitle: Text(
//               order!.hotelName,
//               style: TextStyle(fontSize: 14),
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.hotel, color: Colors.redAccent, size: 20),
//             title: Text(
//               Translations.text('hotelId'),
//               style: TextStyle(fontSize: 14),
//             ),
//             subtitle: Text(
//               order!.hotelId,
//               style: TextStyle(fontSize: 14),
//             ),
//           ),

//           SizedBox(height: 24),

//           // Print Button
//           Center(
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 _showPrintPreview(context);
//               },
//               icon: Icon(Icons.print),
//               label: Text(Translations.text('printReceipt')),
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
//                 textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Additional info based on status
//   Widget _buildAdditionalInfo(BuildContext context) {
//     List<Widget> additionalInfo = [];

//     switch (order!.status.toLowerCase()) {
//       case 'pending':
//         if (hotel != null) {
//           DateTime acceptEndTime =
//               order!.timestamp.add(Duration(minutes: hotel!.acceptMinutes));
//           additionalInfo.addAll([
//             ListTile(
//               leading: Icon(Icons.timer, color: Colors.purple, size: 20),
//               title: Text(
//                 Translations.text('timestamp'),
//                 style: TextStyle(fontSize: 14),
//               ),
//               subtitle: Text(
//                 DateFormat('yyyy-MM-dd – kk:mm').format(order!.timestamp),
//                 style: TextStyle(fontSize: 12),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.access_time, color: Colors.blue, size: 20),
//               title: Text(
//                 Translations.text('acceptMinutesLabel'),
//                 style: TextStyle(fontSize: 14),
//               ),
//               subtitle: Text(
//                 '${hotel!.acceptMinutes} ${Translations.text("minutes")}',
//                 style: TextStyle(fontSize: 12),
//               ),
//             ),
//             SizedBox(height: 8),
//             Row(
//               children: [
//                 Icon(Icons.timer, color: Colors.red, size: 16),
//                 SizedBox(width: 8),
//                 Text(
//                   Translations.text('timeRemaining'),
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(width: 8),
//                 CountdownTimerWidget(
//                   targetTime: acceptEndTime,
//                   onCountdownComplete: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content:
//                             Text(Translations.text('acceptTimeHasExpired')),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ]);
//         }
//         break;

//       case 'kitchen':
//         if (hotel != null) {
//           additionalInfo.add(
//             ListTile(
//               leading: Icon(Icons.kitchen, color: Colors.orange, size: 20),
//               title: Text(
//                 Translations.text('kitchenMinutesLabel'),
//                 style: TextStyle(fontSize: 14),
//               ),
//               subtitle: Text(
//                 '${hotel!.kitchenMinutes} ${Translations.text("minutes")}',
//                 style: TextStyle(fontSize: 12),
//               ),
//             ),
//           );
//         }
//         break;

//       case 'ready':
//       case 'on the way':
//       case 'delivered':
//         if (hotel != null) {
//           additionalInfo.add(
//             ListTile(
//               leading:
//                   Icon(Icons.delivery_dining, color: Colors.green, size: 20),
//               title: Text(
//                 Translations.text('deliveryMinutesLabel'),
//                 style: TextStyle(fontSize: 14),
//               ),
//               subtitle: Text(
//                 '${hotel!.deliveryMinutes} ${Translations.text("minutes")}',
//                 style: TextStyle(fontSize: 12),
//               ),
//             ),
//           );
//         }
//         break;

//       default:
//         additionalInfo.add(
//           ListTile(
//             leading: Icon(Icons.info, color: Colors.grey, size: 20),
//             title: Text(
//               Translations.text('statusInformation'),
//               style: TextStyle(fontSize: 14),
//             ),
//             subtitle: Text(
//               Translations.text('noAdditionalInfo'),
//               style: TextStyle(fontSize: 12),
//             ),
//           ),
//         );
//         break;
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: additionalInfo,
//     );
//   }

//   /// Generate Print Preview
//   void _showPrintPreview(BuildContext context) {
//     if (order == null) return;

//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         insetPadding: EdgeInsets.all(20),
//         child: Container(
//           width: 600,
//           height: 800,
//           child: PdfPreview(
//             build: (format) => _generatePdf(format),
//             allowPrinting: true,
//             allowSharing: false,
//             canChangePageFormat: false,
//             canChangeOrientation: false,
//             initialPageFormat: PdfPageFormat(
//               2 * PdfPageFormat.inch,
//               6 * PdfPageFormat.inch,
//               marginAll: 0.25 * PdfPageFormat.inch,
//             ),
//             onPrinted: (_) => Navigator.of(context).pop(),
//             pdfFileName: 'Receipt_${order!.documentId}.pdf',
//             previewPageMargin: EdgeInsets.all(8),
//           ),
//         ),
//       ),
//     );
//   }

//   /// Generate a PDF in a 2" x 6" format
//   Future<Uint8List> _generatePdf(PdfPageFormat format) async {
//     final pdf = pw.Document();

//     final receiptWidth = 2 * PdfPageFormat.inch;
//     final receiptHeight = 6 * PdfPageFormat.inch;

//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat(receiptWidth, receiptHeight),
//         build: (pw.Context context) {
//           return _buildPdfContent();
//         },
//       ),
//     );

//     return pdf.save();
//   }

//   /// Build PDF content
//   pw.Widget _buildPdfContent() {
//     return pw.Padding(
//       padding: pw.EdgeInsets.all(8.0),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           // Title
//           pw.Center(
//             child: pw.Text(
//               Translations.text('orderReceiptPdf'),
//               style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
//             ),
//           ),
//           pw.Divider(),
//           pw.SizedBox(height: 4),

//           // Basic info
//           pw.Text('${Translations.text("orderId")}: ${order!.documentId}',
//               style: pw.TextStyle(fontSize: 10)),
//           pw.Text(
//               '${Translations.text("customer")}: ${order!.shippingAddress.name}',
//               style: pw.TextStyle(fontSize: 10)),
//           pw.Text(
//             '${Translations.text("date")}: ${DateFormat('yyyy-MM-dd – kk:mm').format(order!.timestamp)}',
//             style: pw.TextStyle(fontSize: 10),
//           ),
//           pw.Divider(),

//           // Items Table
//           pw.Text(Translations.text('itemsLabel'),
//               style: pw.TextStyle(fontSize: 12)),
//           pw.SizedBox(height: 4),
//           pw.Table.fromTextArray(
//             headers: [
//               Translations.text('item'),
//               Translations.text('qty'),
//               Translations.text('price')
//             ],
//             data: order!.cartItems.map((item) {
//               return [
//                 item.dishName,
//                 item.quantity.toString(),
//                 'CHF ${item.price.toStringAsFixed(2)}',
//               ];
//             }).toList(),
//             border: pw.TableBorder.all(width: 0.5, color: PdfColors.black),
//             headerStyle:
//                 pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
//             cellStyle: pw.TextStyle(fontSize: 9),
//             headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
//             cellAlignment: pw.Alignment.centerLeft,
//             headerAlignment: pw.Alignment.centerLeft,
//             columnWidths: {
//               0: pw.FlexColumnWidth(3),
//               1: pw.FlexColumnWidth(1),
//               2: pw.FlexColumnWidth(2),
//             },
//           ),
//           pw.Divider(),

//           // Total
//           pw.Row(
//             mainAxisAlignment: pw.MainAxisAlignment.end,
//             children: [
//               pw.Text(
//                 '${Translations.text("total")}: ',
//                 style:
//                     pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
//               ),
//               pw.Text(
//                 'CHF ${order!.total.toStringAsFixed(2)}',
//                 style:
//                     pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
//               ),
//             ],
//           ),
//           pw.Divider(),

//           // Shipping address
//           pw.Text(Translations.text('shippingAddressLabel'),
//               style: pw.TextStyle(fontSize: 12)),
//           pw.Text(order!.shippingAddress.name,
//               style: pw.TextStyle(fontSize: 10)),
//           pw.Text(order!.shippingAddress.address,
//               style: pw.TextStyle(fontSize: 10)),
//           pw.Text(order!.shippingAddress.country,
//               style: pw.TextStyle(fontSize: 10)),
//           pw.Text(
//             '${Translations.text("mobile")}: ${order!.shippingAddress.mobile}',
//             style: pw.TextStyle(fontSize: 10),
//           ),
//           pw.Divider(),

//           // Payment method + QR
//           pw.Text(Translations.text('paymentMethod'),
//               style: pw.TextStyle(fontSize: 12)),
//           pw.Text(order!.paymentMethod, style: pw.TextStyle(fontSize: 10)),
//           pw.SizedBox(height: 8),
//           pw.Row(
//             crossAxisAlignment: pw.CrossAxisAlignment.center,
//             children: [
//               pw.Text(
//                 '${Translations.text("scanOrderId")}: ',
//                 style:
//                     pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
//               ),
//               pw.SizedBox(width: 4),
//               pw.BarcodeWidget(
//                 data: order!.documentId,
//                 barcode: pw.Barcode.qrCode(),
//                 width: 50,
//                 height: 50,
//               ),
//             ],
//           ),
//           pw.Divider(),

//           // Footer
//           pw.Center(
//             child: pw.Text(
//               Translations.text('thankYouForOrder'),
//               style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending':
//         return const Color.fromARGB(255, 255, 0, 30);
//       case 'kitchen':
//         return Colors.blue;
//       case 'ready':
//       case 'on the way':
//         return Colors.indigo;
//       case 'delivered':
//         return Colors.green;
//       default:
//         return Colors.grey;
//     }
//   }
// }
