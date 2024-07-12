import 'medicine_model.dart';

class PharmacyModel {
  String name;
  String imagePath;
  List<MedicineModel> medicines;
  String address;
  String id;

  PharmacyModel({
    required this.name,
    required this.imagePath,
    required this.address,
    required this.medicines,
    required this.id,
  });

  factory PharmacyModel.fromFirestore(Map<String, dynamic> data, String id) {
    return PharmacyModel(
      id: id,
      name: data['name'] as String,
      imagePath: data['imagePath'] as String,
      address: data['address'] as String,
      medicines: (data['medicines'] as List<dynamic>).map((medicine) {
        return MedicineModel(
          id: medicine['medicineId'] as String,
          name: medicine['medicineName'] as String,
          imagePath: medicine['medicineImagePath'] as String,
          price: medicine['medicinePrice'] as String,
        );
      }).toList(),
    );
  }
}
