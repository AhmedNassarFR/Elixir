import 'dart:io';
import 'package:elexir/widgets/medicine_tile_cart.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../models/order_model.dart';
import '../../models/pharmacy_model.dart';
import '../constants/color.dart';
import '../constants/fonts.dart';
import '../controllers/HomeController.dart';
import '../controllers/MedicineController.dart';
import '../controllers/UserOrdersController.dart';
import '../services/authServices/authServices.dart';
import '../services/firestoreServices/firestore_service.dart';
import '../services/firestoreServices/orders_service.dart';
import '../models/medicine_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Cart extends StatefulWidget {
  Cart({Key? key, required this.userId});

  static const String routeName = "cart";

  final String userId;

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final HomeController controller = Get.put(HomeController());
  final MedicineController medicineController = Get.put(MedicineController());
  final UserOrdersController _ordersController = Get.put(UserOrdersController());

  @override
  Widget build(BuildContext context) {
    _ordersController.fetchOrders(widget.userId);

    return Scaffold(

      body: Column(
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
                          "My Cart",
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
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (_ordersController.orders.isEmpty) {
                return Center(child: Text('No orders found'));
              }

              return ListView.builder(
                itemCount: _ordersController.orders.length,
                itemBuilder: (context, index) {
                  var order = _ordersController.orders[index];
                  return FutureBuilder<MedicineModel?>(
                    future: FirestoreService().getMedicineById(order.pharmacyId, order.medicineId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListTile(
                          title: Text('Loading...'),
                          subtitle: Text('Pharmacy ID: ${order.pharmacyId}'),
                          trailing: Icon(order.isDeliverd ? Icons.check : Icons.close),
                        );
                      }

                      if (!snapshot.hasData) {
                        return ListTile(
                          title: Text('Medicine not found'),
                          subtitle: Text('Pharmacy ID: ${order.pharmacyId}'),
                          trailing: Icon(order.isDeliverd ? Icons.check : Icons.close),
                        );
                      }

                      var medicine = snapshot.data!;
                      return MedicineTileCart(
                        medicine: MedicineModel(
                          id: medicine.id,
                          imagePath: medicine.imagePath,
                          price: medicine.price,
                          name: medicine.name,
                        ),
                        onTap: () async {
                          String? orderId = await OrderService().getOrderIdByUserIdAndMedicineId(AuthService().getCurrentUser()!.uid, medicine.id);
                          if (orderId != null) {
                            await _deleteOrder(orderId);
                          } else {
                            // Handle case where orderId is null (order not found)
                            Get.snackbar('Error', 'Order not found');
                          }
                        },
                      );
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }


  Future<void> _deleteOrder(String orderId) async {
    await OrderService().deleteOrder(orderId);
    _ordersController.fetchOrders(widget.userId); // Refresh list
  }
}

