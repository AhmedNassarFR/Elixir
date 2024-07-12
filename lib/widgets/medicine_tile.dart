import 'package:elexir/constants/color.dart';
import 'package:elexir/models/medicine_model.dart';
import 'package:elexir/models/pharmacy_model.dart';
import 'package:elexir/screens/medicine.dart';
import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import '../screens/homePagePharma.dart';

class MedicineTile extends StatelessWidget {
  MedicineTile({super.key, required this.medicine });

  final MedicineModel medicine;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.all(8),
      child: InkWell(
        onTap: (){Navigator.pushNamed(context, Medicine.routeName);},
        child: Container(
          decoration: BoxDecoration(color: MyColors.lSecondary, borderRadius: BorderRadius.circular(15)),

          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                InkWell(
                  onTap: (){Navigator.pushNamed(context, Medicine.routeName);},
                  child: Row(
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
                            style: TextStyle(color: Colors.white,fontSize: 25,fontFamily: 'OpenSans'),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            medicine.price,
                            style: TextStyle(color: Colors.white,fontSize: 25,fontFamily: 'OpenSans'),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      //onTap: ,
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.4,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 3, color: MyColors.lPrimary),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Edit",
                            textAlign: TextAlign.center,
                            style: MyFonts.outlineButton,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      //onTap: ,
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.4,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.red,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Remove",
                            textAlign: TextAlign.center,
                            style: MyFonts.blueButton,
                          ),
                        ),
                      ),
                    )
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
