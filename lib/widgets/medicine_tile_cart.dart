import 'package:elexir/constants/color.dart';
import 'package:elexir/controllers/MedicineController.dart';
import 'package:elexir/models/medicine_model.dart';
import 'package:elexir/screens/medicine.dart';
import 'package:elexir/services/firestoreServices/orders_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../constants/fonts.dart';
import '../screens/homePagePharma.dart';

class MedicineTileCart extends StatelessWidget {
  MedicineTileCart({super.key, required this.medicine,required this.onTap });

  final MedicineModel medicine;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Get.to(Medicine());;
        },
        child: Container(
          decoration: BoxDecoration(color: MyColors.lSecondary, borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          child: Image.network(
                            medicine.imagePath,
                            width: 10,
                            height: 10,
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
                        SizedBox(width: 5,),
                        Text(
                          medicine.name,
                          style: TextStyle(color: Colors.white, fontSize: 25, fontFamily: 'OpenSans'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          medicine.price,
                          style: TextStyle(color: Colors.white, fontSize: 25, fontFamily: 'OpenSans'),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: 5,),
                Row(mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      alignment: AlignmentDirectional.centerEnd,
                      width: MediaQuery.of(context).size.width * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red,
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: IconButton(icon: Icon(CupertinoIcons.trash), onPressed: () =>
                          onTap
                        ,),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
