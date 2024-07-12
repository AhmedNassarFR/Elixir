import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../models/order_model.dart';
import 'package:elexir/services/firestoreServices/orders_service.dart';

class PharmacyOrdersController extends GetxController {
  var orders = <OrderModel>[].obs;
  OrderService _orderService=OrderService();

  void fetchOrders(String pharmacyId) async {
    var orderList = await _orderService.getOrdersByPharmacyId(pharmacyId);
    orders.value = orderList;
  }
}