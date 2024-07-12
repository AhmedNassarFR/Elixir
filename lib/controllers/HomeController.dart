import 'package:get/get.dart';
import '../../models/pharmacy_model.dart';
import '../services/firestoreServices/firestore_service.dart';

class HomeController extends GetxController {
  final FirestoreService firestoreService = FirestoreService();
  var pharmacies = <PharmacyModel>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPharmacies();
  }

  void fetchPharmacies() async {
    try {
      isLoading(true);
      var result = await firestoreService.getPharmacies();
      pharmacies.assignAll(result);
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
