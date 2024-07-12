import 'package:cloud_firestore/cloud_firestore.dart';

class MedicineModel{


  late String id;
  late String name;
  late String imagePath;
  late String price;
  MedicineModel({required this.name,required this.imagePath,required this.price,required this.id});


  // Add this function to convert Firestore document to MedicineModel
  static MedicineModel fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MedicineModel(
      id: data['medicineId'],
      name: data['medicineName'],
      imagePath: data['medicineImagePath'],
      price: data['medicinePrice'],
    );
  }
}