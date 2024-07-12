import 'package:flutter/material.dart';

import '../constants/fonts.dart';

class Field extends StatelessWidget {
  const Field({required this.isPass, required this.name,required this.controller,required this.onPressed, required this.passVisible});

  final String name;
  final bool isPass;
  final bool passVisible;
  final TextEditingController? controller;
  //
  final void Function()? onPressed;


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: TextFormField(controller: controller,
        obscureText: passVisible,
        decoration: InputDecoration(
            hintText: name,
            hintStyle: MyFonts.smallFontBlue,
            suffixIcon:
                isPass ?  IconButton(onPressed: onPressed,icon: const Icon(Icons.remove_red_eye_outlined)) : null),
      ),
    );
  }
}
