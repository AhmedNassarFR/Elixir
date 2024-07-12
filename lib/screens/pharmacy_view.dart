import 'package:elexir/models/pharmacy_model.dart';
import 'package:elexir/widgets/medicine_tile_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../constants/color.dart';
import '../constants/fonts.dart';
import '../controllers/HomeController.dart';
import '../controllers/MedicineController.dart';
import '../models/medicine_model.dart';
import '../models/order_model.dart';
import '../services/authServices/authServices.dart';
import '../services/firestoreServices/firestore_service.dart';
import '../services/firestoreServices/orders_service.dart';

class PharmacyView extends StatelessWidget {
  PharmacyView({super.key,required this.pharmacy});
  final PharmacyModel pharmacy;
  final HomeController controller = Get.put(HomeController());
  static const String routeName = "pharmacy view";
  //final pharmacy = controller.pharmacies[index];
  final AuthService authService = Get.put(AuthService());

  final MedicineController medicineController = Get.put(MedicineController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, right: 10, left: 10),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Pharmacy",
                              //pharmacy.name,
                              style: MyFonts.heading,
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: CircleAvatar(
                            backgroundColor: MyColors.lPrimary,
                            radius: 24,
                            child: CircleAvatar(
                              radius: 20,
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/profile pic.jpg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        fillColor: MyColors.lBackground,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        hintText: 'Search',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                        prefixIcon: Container(
                          padding: const EdgeInsets.all(15),
                          child: const Icon(Icons.search),
                          width: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10, bottom: 40),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Medicines",
                    style: MyFonts.heading,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 200, // Provide a fixed height for the container
                    child: _buildMedicinesList(pharmacy.id),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildMedicinesList(String pharmacyId) {
    return Obx(() {
      medicineController.fetchMedicines(pharmacyId);
      if (medicineController.medicines.isEmpty) {
        return Center(child: Text('No medicines available.'));
      }
      return ListView.builder(
        itemCount: medicineController.medicines.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          MedicineModel medicine = medicineController.medicines[index];
          return InkWell(
            onTap: () async {
              OrderModel order =OrderModel(pharmacyId: pharmacyId,isDeliverd: false ,isSent: true ,medicineId: medicine.id
                  ,userId: FirebaseAuth.instance.currentUser!.uid);
              await  OrderService().placeOrder(order);
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      medicine.imagePath,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.local_pharmacy,
                            size: 40,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    medicine.name,
                    style: MyFonts.smallLink,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
  }

