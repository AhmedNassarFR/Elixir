import 'package:flutter/material.dart';

import '../constants/color.dart';

class TopLogo extends StatelessWidget {
  const TopLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: CircleAvatar(
        backgroundColor: MyColors.lPrimary,
        radius: 24,
        child: CircleAvatar(
          radius: 20,
          child: ClipOval(
            child: Image.asset(
              'assets/images/profile pic.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.grey,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
