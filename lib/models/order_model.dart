class OrderModel {
  String pharmacyId;
  String userId;
  String medicineId;
  bool isSent;
  bool isDeliverd;

  OrderModel(
      {
      required this.pharmacyId,
      required this.userId,
      required this.isDeliverd,
      required this.isSent,
      required this.medicineId
      });
}
