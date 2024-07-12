import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../models/medicine_model.dart';
import '../models/order_model.dart';
import '../services/firestoreServices/firestore_service.dart';
import '../services/firestoreServices/orders_service.dart';

class UserOrdersController extends GetxController {
  var orders = <OrderModel>[].obs;
  var medicines = <String, MedicineModel>{}.obs; // Store medicine data

  Future<void> fetchOrders(String userId) async {
    var fetchedOrders = await OrderService().getOrdersByUserId(userId);
    orders.value = fetchedOrders;

    // Fetch medicines for each order
    for (var order in fetchedOrders) {
      if (!medicines.containsKey(order.medicineId)) {
        var medicine = await FirestoreService().getMedicineById(order.pharmacyId, order.medicineId);
        if (medicine != null) {
          medicines[order.medicineId] = medicine;
        }
      }
    }
  }
}
