import 'package:flutter/material.dart';

class TitleLogo extends StatelessWidget {
  const TitleLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "JoNdea",
          style: TextStyle(fontSize: 40),
        ),
        Text(
          "생각을 저장하는 나만의 창고",
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}