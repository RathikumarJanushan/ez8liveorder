// lib/home/custom_app_bar.dart

import 'package:ez8liveorder/home/translations/translations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String? displayName;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    // Listen to Firebase auth changes:
    _auth.authStateChanges().listen((user) {
      setState(() {
        // If user is null, show "Sign In / Register" in the current language
        displayName =
            user?.email?.split('@')[0] ?? Translations.text('signInRegister');
      });
    });

    // Listen to language changes to update displayName if necessary
    Translations.currentLanguage.addListener(() {
      setState(() {
        if (_auth.currentUser == null) {
          displayName = Translations.text('signInRegister');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 243, 33, 33),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left logo
          Row(
            children: [
              Image.asset(
                'assets/img/quickrunez8.jpg',
                height: 40,
              ),
              SizedBox(width: 20),
            ],
          ),

          // Right side
          Row(
            children: [
              // Display user name or sign in/register
              Text(
                displayName ?? '',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(width: 16),

              // Language selection popup
              PopupMenuButton<String>(
                icon: Icon(Icons.language, color: Colors.white),
                onSelected: (String language) {
                  Translations.currentLanguage.value = language;
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'German',
                    child: Text('German'),
                  ),
                  PopupMenuItem(
                    value: 'French',
                    child: Text('French'),
                  ),
                  PopupMenuItem(
                    value: 'English',
                    child: Text('English'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
