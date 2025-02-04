// lib/home/DetailsPage/hotel_details_widget.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez8liveorder/models/hotel.dart';
import 'package:ez8liveorder/home/translations/translations.dart';
import 'package:flutter/material.dart';

class HotelDetailsWidget extends StatefulWidget {
  final Hotel hotel;

  const HotelDetailsWidget({Key? key, required this.hotel}) : super(key: key);

  @override
  _HotelDetailsWidgetState createState() => _HotelDetailsWidgetState();
}

class _HotelDetailsWidgetState extends State<HotelDetailsWidget> {
  late TextEditingController _acceptMinutesController;
  late TextEditingController _kitchenMinutesController;
  late TextEditingController _deliveryMinutesController;

  String? _acceptMinutesError;
  String? _kitchenMinutesError;
  String? _deliveryMinutesError;

  @override
  void initState() {
    super.initState();
    _acceptMinutesController =
        TextEditingController(text: widget.hotel.acceptMinutes.toString());
    _kitchenMinutesController =
        TextEditingController(text: widget.hotel.kitchenMinutes.toString());
    _deliveryMinutesController =
        TextEditingController(text: widget.hotel.deliveryMinutes.toString());
  }

  @override
  void dispose() {
    _acceptMinutesController.dispose();
    _kitchenMinutesController.dispose();
    _deliveryMinutesController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    bool isValid = true;

    setState(() {
      // Accept Minutes
      if (_acceptMinutesController.text.isEmpty) {
        _acceptMinutesError = Translations.text('acceptMinutesEmpty');
        isValid = false;
      } else {
        final int? minutes = int.tryParse(_acceptMinutesController.text);
        if (minutes == null || minutes <= 0) {
          _acceptMinutesError = Translations.text('invalidNumberOfMinutes');
          isValid = false;
        } else {
          _acceptMinutesError = null;
        }
      }

      // Kitchen Minutes
      if (_kitchenMinutesController.text.isEmpty) {
        _kitchenMinutesError = Translations.text('kitchenMinutesEmpty');
        isValid = false;
      } else {
        final int? minutes = int.tryParse(_kitchenMinutesController.text);
        if (minutes == null || minutes <= 0) {
          _kitchenMinutesError = Translations.text('invalidNumberOfMinutes');
          isValid = false;
        } else {
          _kitchenMinutesError = null;
        }
      }

      // Delivery Minutes
      if (_deliveryMinutesController.text.isEmpty) {
        _deliveryMinutesError = Translations.text('deliveryMinutesEmpty');
        isValid = false;
      } else {
        final int? minutes = int.tryParse(_deliveryMinutesController.text);
        if (minutes == null || minutes <= 0) {
          _deliveryMinutesError = Translations.text('invalidNumberOfMinutes');
          isValid = false;
        } else {
          _deliveryMinutesError = null;
        }
      }
    });

    return isValid;
  }

  Future<void> _updateHotelMinutes() async {
    if (!_validateInputs()) return;

    try {
      final int acceptMinutes = int.parse(_acceptMinutesController.text);
      final int kitchenMinutes = int.parse(_kitchenMinutesController.text);
      final int deliveryMinutes = int.parse(_deliveryMinutesController.text);

      await FirebaseFirestore.instance
          .collection('hotels')
          .doc(widget.hotel.id)
          .update({
        'accept_minutes': acceptMinutes,
        'kitchen_minutes': kitchenMinutes,
        'delivery_minutes': deliveryMinutes,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Translations.text('hotelMinutesUpdated'))),
      );
    } catch (e) {
      print('Error updating hotel minutes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Translations.text('hotelMinutesUpdateFailed'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Translations.text('hotelDetailsHeader'),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          Divider(thickness: 2),
          SizedBox(height: 16),
          // Hotel Information
          ListTile(
            leading: Icon(Icons.location_city, color: Colors.blue),
            title: Text(
              widget.hotel.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(widget.hotel.address),
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.phone, color: Colors.green),
            title: Text(Translations.text('phone')),
            subtitle: Text(widget.hotel.phone),
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.orange),
            title: Text(Translations.text('status')),
            subtitle: Text(widget.hotel.status),
          ),
          Divider(thickness: 2),
          SizedBox(height: 16),

          // Accept Minutes
          Text(
            '${Translations.text('acceptMinutesLabel')}:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: _acceptMinutesController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: Translations.text('enterAcceptMinutes'),
              errorText: _acceptMinutesError,
            ),
            onChanged: (value) {
              _validateInputs();
            },
          ),
          SizedBox(height: 16),

          // Kitchen Minutes
          Text(
            '${Translations.text('kitchenMinutesLabel')}:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: _kitchenMinutesController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: Translations.text('enterKitchenMinutes'),
              errorText: _kitchenMinutesError,
            ),
            onChanged: (value) {
              _validateInputs();
            },
          ),
          SizedBox(height: 16),

          // Delivery Minutes
          Text(
            '${Translations.text('deliveryMinutesLabel')}:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: _deliveryMinutesController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: Translations.text('enterDeliveryMinutes'),
              errorText: _deliveryMinutesError,
            ),
            onChanged: (value) {
              _validateInputs();
            },
          ),
          SizedBox(height: 24),

          // Update Button
          ElevatedButton.icon(
            onPressed: _updateHotelMinutes,
            icon: Icon(Icons.save),
            label: Text(Translations.text('updateMinutesButton')),
          ),
        ],
      ),
    );
  }
}
