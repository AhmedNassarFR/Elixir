import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'color.dart';

class MyFonts {
  static  TextStyle heading = TextStyle(
    color: MyColors.lPrimary,
    fontSize: 36.sp,
    fontWeight: FontWeight.bold,
  );
  static  TextStyle headingOrange = TextStyle(
    color: MyColors.lAccent,
    fontSize: 36.sp,
    fontWeight: FontWeight.bold,
  );
  static  TextStyle smallFontBlue = TextStyle(
    color: MyColors.lSecondary,
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
  );
  static  TextStyle blueButton = TextStyle(
    color: Colors.white,
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
  );
  static  TextStyle outlineButton = TextStyle(
    color: MyColors.lPrimary,
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
  );
  static  TextStyle normalText = TextStyle(
    color: MyColors.lText,
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
  );
  static  TextStyle smallLink = TextStyle(
    color: MyColors.lAccent,
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline,
    decorationColor: MyColors.lAccent,
  );
}
