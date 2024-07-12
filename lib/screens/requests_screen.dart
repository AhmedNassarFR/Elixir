import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/PharmacyOrdersController.dart';

class PharmacyOrdersPage extends StatelessWidget {
  final String pharmacyId;
  final PharmacyOrdersController controller = Get.put(PharmacyOrdersController());

  PharmacyOrdersPage({required this.pharmacyId});

  @override
  Widget build(BuildContext context) {
    controller.fetchOrders(pharmacyId);

    return Scaffold(
      appBar: AppBar(title: Text('Pharmacy Orders')),
      body: Obx(() {
        if (controller.orders.isEmpty) {
          return Center(child: Text('No orders found'));
        }

        return ListView.builder(
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            var order = controller.orders[index];
            return ListTile(
              title: Text(order.medicineId),
              subtitle: Text('User ID: ${order.userId}'),
              trailing: Icon(order.isDeliverd ? Icons.check : Icons.close),
            );
          },
        );
      }),
    );
  }
}