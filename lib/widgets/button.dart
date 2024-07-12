import 'package:flutter/material.dart';

import '../constants/color.dart';
import '../constants/fonts.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {required this.text, required this.onPressed, required this.isOutline});

  final String text;
  final VoidCallback onPressed;
  final bool isOutline;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
        child: isOutline
            ? InkWell(
                onTap: onPressed,
                child: Container(
                  width: 360,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 3, color: MyColors.lPrimary),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: MyFonts.outlineButton,
                    ),
                  ),
                ),
              )
            : InkWell(
                onTap: onPressed,
                child: Container(
                  width: 360,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: MyColors.lPrimary,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: MyFonts.blueButton,
                    ),
                  ),
                ),
              ));
  }
}
