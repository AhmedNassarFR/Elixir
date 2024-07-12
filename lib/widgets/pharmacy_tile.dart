import 'package:elexir/models/pharmacy_model.dart';
import 'package:elexir/screens/pharmacy_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/fonts.dart';
import '../screens/homePagePharma.dart';

class PharmacyTile extends StatelessWidget {
  const PharmacyTile({super.key, required this.pharmacy});

  final PharmacyModel pharmacy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: (){Get.to(PharmacyView( pharmacy: pharmacy,));},
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                pharmacy.imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.local_pharmacy,
                      size: 40,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 5),
            Text(
              pharmacy.name,
              style: MyFonts.smallLink,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
