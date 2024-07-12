import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import 'corner_arc.dart';

class TopArcStack extends StatelessWidget {
  const TopArcStack({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            arc(),
          ],
        ),
        Positioned(
          top: 110,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: MyFonts.heading,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
