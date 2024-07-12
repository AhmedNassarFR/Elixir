import 'package:get/get.dart';
import 'package:elexir/models/medicine_model.dart';
import 'package:elexir/services/firestoreServices/firestore_service.dart';

class MedicineController extends GetxController {
  var medicines = <MedicineModel>[].obs;
  var searchResults = <MedicineModel>[].obs;
  var isSearching = false.obs;
  final FirestoreService firestoreService = FirestoreService();

  void fetchMedicines(String pharmacyId) async {
    var result = await firestoreService.getMedicines(pharmacyId);
    medicines.value = result;
  }

  void addMedicine(String pharmacyId, MedicineModel medicine) async {
    await firestoreService.addMedicine(pharmacyId, medicine);
    fetchMedicines(pharmacyId);
  }

  void updateMedicine(String pharmacyId, MedicineModel oldMedicine, MedicineModel newMedicine) async {
    await firestoreService.updateMedicine(pharmacyId, oldMedicine, newMedicine);
    fetchMedicines(pharmacyId);
  }

  void deleteMedicine(String pharmacyId, MedicineModel medicine) async {
    await firestoreService.deleteMedicine(pharmacyId, medicine);
    fetchMedicines(pharmacyId);
  }

  void searchMedicinesByName(String query) async {
    try {
      isSearching.value = true;
      searchResults.clear();
      final results = await firestoreService.searchMedicinesByName(query);
      searchResults.assignAll(results);
    } finally {
      isSearching.value = false;
    }
  }
}
