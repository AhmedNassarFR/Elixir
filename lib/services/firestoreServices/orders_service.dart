import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/order_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> placeOrder(OrderModel order) async {
    await _firestore.collection('orders').add({
      'pharmacyId': order.pharmacyId,
      'userId': order.userId,
      'medicineId': order.medicineId,
      'isSent': order.isSent,
      'isDeliverd': order.isDeliverd,
    });
  }

  Future<void> deliverOrder(String orderId) async {
    await _firestore.collection('orders').doc(orderId).update({
      'isDeliverd': true,
    });
  }

  Future<List<OrderModel>> getOrdersByPharmacyId(String pharmacyId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('orders')
        .where('pharmacyId', isEqualTo: pharmacyId)
        .get();

    return querySnapshot.docs.map((doc) =>
        OrderModel(
          pharmacyId: doc['pharmacyId'],
          userId: doc['userId'],
          medicineId: doc['medicineId'],
          isSent: doc['isSent'],
          isDeliverd: doc['isDeliverd'],
        )).toList();
  }


  Future<List<OrderModel>> getOrdersByUserId(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .get();

    return querySnapshot.docs.map((doc) =>
        OrderModel(
          pharmacyId: doc['pharmacyId'],
          userId: doc['userId'],
          medicineId: doc['medicineId'],
          isSent: doc['isSent'],
          isDeliverd: doc['isDeliverd'],
        )).toList();
  }


  Future<void> deleteOrder(String orderId) async {
    await _firestore.collection('orders').doc(orderId).delete();
  }

  Future<String?> getOrderIdByUserIdAndMedicineId(String userId,
      String medicineId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .where('medicineId', isEqualTo: medicineId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      return null;
    }
  }

}
