import 'package:elexir/screens/homePageContentPharma.dart';
import 'package:elexir/screens/requests_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:elexir/screens/homePage.dart';
import 'package:elexir/screens/cart.dart';
import 'package:elexir/screens/morePharmacy.dart';
import 'package:get/get.dart';
import 'package:elexir/models/medicine_model.dart';
import 'package:elexir/services/firestoreServices/firestore_service.dart';
import 'package:elexir/constants/color.dart';
import 'package:elexir/constants/fonts.dart';
import 'package:elexir/services/authServices/authServices.dart';
import '../controllers/HomeController.dart';
import '../controllers/MedicineController.dart'; // Import the controller

class HomePagePharmacy extends StatefulWidget {
  HomePagePharmacy({super.key});

  static const String routeName = "homePagePharma";

  @override
  State<HomePagePharmacy> createState() => _HomePagePharmacyState();
}

class _HomePagePharmacyState extends State<HomePagePharmacy> {
  final HomeController controller = Get.put(HomeController());

  //final pharmacy = controller.pharmacies[index];
  final AuthService authService = Get.put(AuthService());

  final MedicineController medicineController = Get.put(MedicineController());

  int _currentIndex = 0;

  final List<Widget> _screens = [
     HomeScreenPharma(), // Update with your actual home screen widget
    PharmacyOrdersPage(pharmacyId: FirebaseAuth.instance.currentUser!.uid ,), // Update with your actual cart screen widget
    const MorePharmacy(), // Placeholder, replace with actual "More" screen widget if available
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });

  }

  @override
  Widget build(BuildContext context) {
    final String pharmacyId = authService.getCurrentUser()!.uid;
    medicineController.fetchMedicines(pharmacyId); // Fetch medicines on init

    return Scaffold(

      body: IndexedStack(
        children: _screens,
        index: _currentIndex,
      ),
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
