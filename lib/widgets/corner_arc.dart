import 'package:flutter/material.dart';

import '../constants/color.dart';

class arc extends StatelessWidget {
  const arc({super.key});

  //static double length = MediaQuery.of(context).size.width*0.46;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(180)),
        color: MyColors.lPrimary,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 40, bottom: 40),
        child: Align(
          alignment: Alignment.center,
          child: Image.asset(
            'assets/images/elixir-icon.png',
            width: 73,
            height: 48,
          ),
        ),
      ),
    );
  }
}
