import 'dart:io';
import 'package:elexir/widgets/medicine_tile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../constants/color.dart';
import '../constants/fonts.dart';
import '../controllers/HomeController.dart';
import '../controllers/MedicineController.dart';
import '../models/medicine_model.dart';
import '../services/authServices/authServices.dart';
import '../services/firestoreServices/firestore_service.dart';

class HomeScreenPharma extends StatefulWidget {
  HomeScreenPharma({super.key});

  @override
  State<HomeScreenPharma> createState() => _HomeScreenPharmaState();
}

class _HomeScreenPharmaState extends State<HomeScreenPharma> {
  final TextEditingController imagePathController = TextEditingController();
  final HomeController controller = Get.put(HomeController());
  final AuthService authService = Get.put(AuthService());
  final MedicineController medicineController = Get.put(MedicineController());
  final ImagePicker _picker = ImagePicker();
  File? _image;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    final String pharmacyId = authService.getCurrentUser()!.uid;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddMedicineDialog(context, pharmacyId);
        },
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                          Text(
                            "Pharmacy",
                            style: MyFonts.heading,
                          ),
                          CircleAvatar(
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
                    SizedBox(height: 650,
                        child: _buildMedicinesList(pharmacyId)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicinesList(String pharmacyId) {
    return Obx(() {
      if (medicineController.medicines.isEmpty) {
        return Center(child: Text('No medicines available.'));
      }
      return ListView.builder(
        itemCount: medicineController.medicines.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          MedicineModel medicine = medicineController.medicines[index];
          return MedicineTile(medicine: medicine);
        },
      );
    });
  }

  void _showAddMedicineDialog(BuildContext context, String pharmacyId) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    Get.defaultDialog(
      title: 'Add Medicine',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Medicine Name',
            ),
          ),
          GestureDetector(
            onTap: pickImage,
            child: CircleAvatar(
              backgroundColor: MyColors.lPrimary,
              radius: 75,
              backgroundImage: _image != null ? FileImage(_image!) : null,
              child: _image == null
                  ? const Icon(Icons.camera_alt, color: MyColors.lBackground, size: 50)
                  : null,
            ),
          ),
          TextField(
            controller: priceController,
            decoration: InputDecoration(
              hintText: 'Price',
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              var uuid = Uuid(); // Create a Uuid object
              String medicineId = uuid.v4(); // Generate a new UUID

              String? imageUrl = await uploadImage(_image!);

              if (imageUrl != null) {
                await FirestoreService().addMedicine(
                  pharmacyId,
                  MedicineModel(
                    id: medicineId,
                    name: nameController.text,
                    imagePath: imageUrl,
                    price: priceController.text,
                  ),
                );

                medicineController.fetchMedicines(pharmacyId); // Refresh list
                Get.back(); // Close dialog or navigate back
              } else {
                Get.snackbar('Error', 'Failed to upload image.');
              }
            },
            child: Text('Add Medicine'),
          ),
        ],
      ),
    );
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> uploadImage(File image) async {
    try {
      Reference storageRef = _storage.ref().child('medicines/${DateTime.now().millisecondsSinceEpoch}.jpg');
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
