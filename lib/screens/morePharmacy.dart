import 'package:flutter/material.dart';
import '../../models/pharmacy_model.dart';
import '../constants/color.dart';
import '../constants/fonts.dart';
import '../services/DisplayImage.dart';
import '../services/authServices/authServices.dart';
import '../services/firestoreServices/firestore_service.dart';

class MorePharmacy extends StatefulWidget {
  const MorePharmacy({Key? key}) : super(key: key);

  static const String routeName = "more";

  @override
  _MorePharmacyState createState() => _MorePharmacyState();
}

class _MorePharmacyState extends State<MorePharmacy> {
  final AuthService authService =
      AuthService(); // Replace with your authentication service
  late final String pharmacyId;

  @override
  void initState() {
    super.initState();
    pharmacyId = authService.getCurrentUser()!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
        child: FutureBuilder<PharmacyModel?>(
          future: FirestoreService().getPharmacyById(pharmacyId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              PharmacyModel? pharmacyInfo = snapshot.data;

              if (pharmacyInfo == null) {
                return Center(child: Text('No pharmacy information found.'));
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          "${pharmacyInfo.name}",
                          style: MyFonts.heading,
                        ),
                        SizedBox(height: 20,),
                        Container(
                            width: 150,
                            decoration: BoxDecoration(
                                color: MyColors.lPrimary,
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                child: DisplayImage(
                                  pharmacyId: pharmacyId,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  buildRow("Email", authService.getCurrentUser()!.email ?? ""),

                  buildRow("Address", pharmacyInfo.address ?? ""),
                  // buildRow("Payment info", pharmacyInfo.paymentInfo ?? ""),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title + ": ",
            style: MyFonts.outlineButton,
          ),
          Expanded(
            child: Text(
              value,
              style: MyFonts.normalText,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
