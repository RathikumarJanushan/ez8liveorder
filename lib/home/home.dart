// lib/home/home_page.dart

import 'package:ez8liveorder/home/custom_app_bar.dart'; // Ensure this path is correct
import 'package:ez8liveorder/home/translations/translations.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Adjust the path as necessary
import 'DetailsPage/details_page.dart'; // Ensure this path is correct

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controllers to retrieve the text input values
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Loading state
  bool _isLoading = false;

  // Method to handle authentication
  Future<void> _authenticate() async {
    // Validate form inputs
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String name = nameController.text.trim();
    String password = passwordController.text.trim();

    try {
      // Query Firestore for a matching document based on 'name' and 'password'
      QuerySnapshot query = await _firestore
          .collection('hotels')
          .where('name', isEqualTo: name)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        // If a matching document is found, navigate to DetailsPage
        DocumentSnapshot hotelData = query.docs.first;

        // Debugging: Print fetched data (optional)
        print('Hotel Data: ${hotelData.data()}');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(
              name: hotelData['name'] ?? 'N/A',
            ),
          ),
        );
      } else {
        // Show error if credentials do not match
        _showErrorDialog(Translations.text('invalidCredentials'));
      }
    } catch (e) {
      // Handle errors (e.g., network issues)
      _showErrorDialog(Translations.text('authenticationError'));
      print('Error during authentication: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method to show error dialogs
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(Translations.text('authenticationFailed')),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(Translations.text('okay')),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers when not needed to free up resources
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Translations.currentLanguage,
      builder: (context, value, child) {
        return Scaffold(
          appBar:
              CustomAppBar(), // Ensure CustomAppBar is correctly implemented
          body: Center(
            child: SingleChildScrollView(
              // To handle keyboard overflow
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 32.0, horizontal: 24.0),
                    child: Form(
                      // Use Form for validation
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Welcome message
                          Text(
                            Translations.text('welcomeMessage'),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 40),

                          // Name input field
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: Translations.text('name'),
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return Translations.text('nameRequired');
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),

                          // Password input field
                          TextFormField(
                            controller: passwordController,
                            obscureText: true, // Masks the password
                            decoration: InputDecoration(
                              labelText: Translations.text('password'),
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return Translations.text('passwordRequired');
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 30),

                          // Submit button or loading indicator
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: _isLoading
                                ? Center(child: CircularProgressIndicator())
                                : ElevatedButton(
                                    onPressed: _authenticate,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 243, 33, 33),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      Translations.text('login'),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
