import 'package:elexir/screens/sign_in.dart';
import 'package:elexir/screens/homePagePharma.dart';
import 'package:elexir/screens/welcome.dart';
import 'package:elexir/services/authServices/authServices.dart';
import 'package:elexir/services/firestoreServices/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../screens/homePage.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({Key? key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      // User is not authenticated
      return Welcome(); // Replace with your sign-in screen widget
    } else {
      // User is authenticated
      return FutureBuilder<bool>(
        future: FirestoreService().isPharmacy(AuthService().getCurrentUser()!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error loading data'),
              ),
            );
          } else {
            bool isPharmacy = snapshot.data ?? false;
            if (isPharmacy) {
              // Navigate to Pharmacy Home Page
              return HomePagePharmacy();
            } else {
              // Navigate to User Home Page
              return HomePage(); // Replace with your user home page widget
            }
          }
        },
      );
    }
  }
}
