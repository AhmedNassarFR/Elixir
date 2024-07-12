import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/pharmacy_model.dart';
import '../../models/medicine_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> addPharmacy(PharmacyModel pharmacy) async {
    DocumentReference docRef = _db.collection('pharmacies').doc(pharmacy.id);
    await docRef.set({
      'pharmacyId': pharmacy.id,
      'name': pharmacy.name,
      'imagePath': pharmacy.imagePath,
      'address': pharmacy.address,
      'medicines': pharmacy.medicines.map((medicine) => {
        'medicineId': medicine.id,
        'medicineName': medicine.name,
        'medicineImagePath': medicine.imagePath,
        'medicinePrice': medicine.price,
      }).toList(),
    });
    return docRef.id;
  }

  Future<List<PharmacyModel>> getPharmacies() async {
    QuerySnapshot snapshot = await _db.collection('pharmacies').get();
    return snapshot.docs.map((doc) {
      return PharmacyModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<void> addMedicine(String pharmacyId, MedicineModel medicine) async {
    try {
      DocumentReference pharmacyRef = _db.collection('pharmacies').doc(pharmacyId);
      await pharmacyRef.update({
        'medicines': FieldValue.arrayUnion([
          {
            'medicineId': medicine.id,
            'medicineName': medicine.name,
            'medicineImagePath': medicine.imagePath,
            'medicinePrice': medicine.price,
          }
        ])
      });
      print('Medicine added successfully.');
    } catch (e) {
      print('Error adding medicine: $e');
    }
  }

  Future<void> updateMedicine(String pharmacyId, MedicineModel oldMedicine, MedicineModel newMedicine) async {
    DocumentReference pharmacyRef = _db.collection('pharmacies').doc(pharmacyId);
    await pharmacyRef.update({
      'medicines': FieldValue.arrayRemove([
        {
          'medicineId': oldMedicine.id,
          'medicineName': oldMedicine.name,
          'medicineImagePath': oldMedicine.imagePath,
          'medicinePrice': oldMedicine.price,
        }
      ]),
    });
    await pharmacyRef.update({
      'medicines': FieldValue.arrayUnion([
        {
          'medicineId': newMedicine.id,
          'medicineName': newMedicine.name,
          'medicineImagePath': newMedicine.imagePath,
          'medicinePrice': newMedicine.price,
        }
      ])
    });
  }

  Future<List<MedicineModel>> getMedicines(String pharmacyId) async {
    DocumentSnapshot snapshot = await _db.collection('pharmacies').doc(pharmacyId).get();
    List medicines = snapshot['medicines'];
    return medicines.map((medicine) {
      return MedicineModel(
        id: medicine['medicineId'],
        name: medicine['medicineName'],
        imagePath: medicine['medicineImagePath'],
        price: medicine['medicinePrice'],
      );
    }).toList();
  }

  Future<void> deleteMedicine(String pharmacyId, MedicineModel medicine) async {
    DocumentReference pharmacyRef = _db.collection('pharmacies').doc(pharmacyId);
    await pharmacyRef.update({
      'medicines': FieldValue.arrayRemove([
        {
          'medicineId': medicine.id,
          'medicineName': medicine.name,
          'medicineImagePath': medicine.imagePath,
          'medicinePrice': medicine.price,
        }
      ]),
    });
  }

  Future<String?> getPharmacyIdByName(String name) async {
    QuerySnapshot snapshot = await _db.collection('pharmacies').where('name', isEqualTo: name).get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    }
    return null;
  }

  Future<String?> getDocumentIdByPharmacyId(String pharmacyId) async {
    QuerySnapshot snapshot = await _db.collection('pharmacies').where('pharmacyId', isEqualTo: pharmacyId).get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    }
    return null;
  }

  Future<PharmacyModel?> getPharmacyById(String pharmacyId) async {
    DocumentSnapshot doc = await _db.collection('pharmacies').doc(pharmacyId).get();
    if (doc.exists) {
      return PharmacyModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Future<bool> isPharmacy(String userId) async {
    DocumentSnapshot snapshot = await _db.collection('pharmacies').doc(userId).get();
    return snapshot.exists;
  }

  Future<MedicineModel?> getMedicineById(String pharmacyId, String medicineId) async {
    try {
      DocumentSnapshot snapshot = await _db.collection('pharmacies').doc(pharmacyId).get();
      if (snapshot.exists) {
        List medicines = (snapshot.data() as Map<String, dynamic>)['medicines'];
        var medicineData = medicines.firstWhere((medicine) => medicine['medicineId'] == medicineId, orElse: () => null);
        if (medicineData != null) {
          return MedicineModel(
            id: medicineData['medicineId'],
            name: medicineData['medicineName'],
            imagePath: medicineData['medicineImagePath'],
            price: medicineData['medicinePrice'],
          );
        }
      }
    } catch (e) {
      print('Error fetching medicine: $e');
    }
    return null;
  }

  Future<List<MedicineModel>> searchMedicinesByName(String name) async {
    try {
      QuerySnapshot snapshot = await _db.collection('pharmacies').get();
      List<MedicineModel> medicines = [];
      for (var doc in snapshot.docs) {
        List pharmacyMedicines = doc['medicines'];
        var filteredMedicines = pharmacyMedicines.where((medicine) =>
            (medicine['medicineName'] as String).toLowerCase().contains(name.toLowerCase()));
        for (var medicine in filteredMedicines) {
          medicines.add(MedicineModel(
            id: medicine['medicineId'],
            name: medicine['medicineName'],
            imagePath: medicine['medicineImagePath'],
            price: medicine['medicinePrice'],
          ));
        }
      }
      return medicines;
    } catch (e) {
      print('Error searching medicines: $e');
      return [];
    }
  }
}
