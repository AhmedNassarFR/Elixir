
import 'package:elexir/screens/homePageContent.dart';
import 'package:elexir/screens/homePagePharma.dart';
import 'package:elexir/services/authServices/authServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:elexir/screens/cart.dart';
import 'package:elexir/screens/morePharmacy.dart';
import 'package:elexir/screens/homePagePharma.dart';
import 'package:get/get.dart';
import '../../models/pharmacy_model.dart';
import '../constants/color.dart';
import '../constants/fonts.dart';
import '../controllers/HomeController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'more.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = "home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController controller = Get.put(HomeController());
  int _currentIndex = 0;

  final List<Widget> _screens = [
     HomeScreen(), // Update with your actual home screen widget
     Cart(userId: FirebaseAuth.instance.currentUser!.uid,), // Update with your actual cart screen widget
    const More(), // Placeholder, replace with actual "More" screen widget if available
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: _screens,
        index: _currentIndex,
      ) ,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: MyColors.lSecondary),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, color: MyColors.lSecondary),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz, color: MyColors.lSecondary),
            label: "More",
          ),
        ],
      ),
    );
  }
}
