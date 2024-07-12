import 'package:elexir/services/authServices/authServices.dart';
import 'package:elexir/widgets/medicine_tile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/color.dart';
import '../constants/fonts.dart';
import '../controllers/HomeController.dart';
import '../controllers/MedicineController.dart';
import '../models/medicine_model.dart';
import '../widgets/medicine_tile.dart';
import '../widgets/pharmacy_tile.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeController controller = Get.put(HomeController());
  final MedicineController medicineController = Get.put(MedicineController());
  final TextEditingController searchController = TextEditingController();

  void _searchMedicines() {
    final query = searchController.text.trim();
    if (query.isNotEmpty) {
      medicineController.searchMedicinesByName(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                            "Welcome ",
                            style: MyFonts.heading,
                          ),
                        ],
                      ),
                     IconButton(onPressed: (){AuthService().signOut();}, icon: Icon(Icons.logout))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    controller: searchController,
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
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: _searchMedicines,
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
                  "Pharmacies",
                  style: MyFonts.heading,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            if (medicineController.isSearching.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (medicineController.searchResults.isNotEmpty) {
              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: medicineController.searchResults.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 1 / 0.5,
                ),
                itemBuilder: (context, index) {
                  final medicine = medicineController.searchResults[index];
                  return MedicineTileView(medicine: medicine);
                },
              );
            }

            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            if (controller.errorMessage.isNotEmpty) {
              return Center(child: Text('Error: ${controller.errorMessage}'));
            }
            if (controller.pharmacies.isEmpty) {
              return Center(child: Text('No pharmacies available.'));
            }

            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: controller.pharmacies.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1,
              ),
              itemBuilder: (context, index) {
                final pharmacy = controller.pharmacies[index];
                return PharmacyTile(pharmacy: pharmacy);
              },
            );
          }),
        ),
      ],
    );
  }
}
