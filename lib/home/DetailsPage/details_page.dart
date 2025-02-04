// lib/home/DetailsPage/details_page.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez8liveorder/home/DetailsPage/bill_orders_widget.dart';
import 'package:ez8liveorder/home/DetailsPage/hotel_details_widget.dart';
import 'package:ez8liveorder/home/custom_app_bar.dart';
import 'package:ez8liveorder/home/translations/translations.dart';
import 'package:ez8liveorder/models/hotel.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  final String name;
  const DetailsPage({Key? key, required this.name}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Hotel? hotel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHotelDetails();
  }

  /// Fetch hotel details based on the name provided to this page.
  Future<void> _fetchHotelDetails() async {
    try {
      final query = FirebaseFirestore.instance
          .collection('hotels')
          .where('name', isEqualTo: widget.name)
          .limit(1)
          .snapshots();

      // Listen to hotel changes in real time.
      query.listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          final doc = snapshot.docs.first;
          setState(() {
            hotel = Hotel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
            isLoading = false;
          });
        } else {
          setState(() {
            hotel = null;
            isLoading = false;
          });
        }
      });
    } catch (e) {
      debugPrint('Error fetching hotel details: $e');
      setState(() {
        hotel = null;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Translations.currentLanguage,
      builder: (context, currentLang, child) {
        if (isLoading) {
          return Scaffold(
            appBar: CustomAppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (hotel == null) {
          return Scaffold(
            appBar: CustomAppBar(),
            body: Center(
              child: Text(
                '${Translations.text("noDetailsFoundFor")} ${widget.name}',
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
          );
        }

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: CustomAppBar(),
            body: Column(
              children: [
                // Header with hotel name and "Details" label.
                Container(
                  width: double.infinity,
                  color: Colors.redAccent,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '${hotel!.name} ${Translations.text("details")}',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                // Tabs for Bill Orders and Hotel Details.
                TabBar(
                  labelColor: Colors.redAccent,
                  indicatorColor: Colors.redAccent,
                  tabs: [
                    Tab(text: Translations.text('billOrders')),
                    Tab(text: Translations.text('hotelDetails')),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Bill Orders Tab.
                      BillOrdersWidget(hotelId: hotel!.id),
                      // Hotel Details Tab.
                      HotelDetailsWidget(hotel: hotel!),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
