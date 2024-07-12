import 'package:flutter/material.dart';

import '../constants/color.dart';
import '../constants/fonts.dart';

class Medicine extends StatelessWidget {
  const Medicine({super.key});

  static const String routeName = "medicine";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, right: 10, left: 10),
            child: Container(
              decoration: const BoxDecoration(
                //color: Colors.white,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Text(
                      "Medicine",
                      //pharmacy.name,
                      style: MyFonts.heading,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: 150,
                        decoration: BoxDecoration(
                            color: MyColors.lPrimary,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(child: Icon(Icons.medical_information)
                            //borderRadius: BorderRadius.circular(20),
                          ),
                        )),
                    Text("Price", style: MyFonts.normalText,)
                  ],
                ),
              ),
            ),
          ),
        ]));
  }
}
