import 'package:flutter/material.dart';
import 'dart:html';

class TitleLogo extends StatelessWidget {
  TitleLogo({super.key});

  Widget thinkingHat = Image.asset("assets/thinking_J.png", height: 86);

  Widget bigTitle = Row(
    children: [
      Text(
        "O'",
        style: TextStyle(
          fontSize: 52,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: "pixel",
          shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 3, offset: Offset(2, 2))],
        ),
      ),
      Text(
        "NDEA",
        style: TextStyle(
          fontSize: 52,
          letterSpacing: 3,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: "pixel",
          shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 3, offset: Offset(2, 2))],
        ),
      ),
    ],
  );

  Widget smallTitle = const Text(
    "조씨의 좋은 아이디어 저장소",
    style: TextStyle(
      fontSize: 15,
      color: Colors.white,
      fontFamily: "leeseoyoon",
      letterSpacing: 0.6,
    ),
  );

  Widget logo() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          window.location.reload();
        },
        child: SizedBox(
          width: 240,
          height: 100,
          child: Stack(
            children: [
              Positioned(top: 2, right: 0, child: bigTitle),
              Positioned(bottom: 20, right: 2.5, child: smallTitle),
              Positioned(child: thinkingHat),
            ],
          ),
        ),
      ),
    );
  }

  Widget background({Widget? child}) => Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(64, 72, 66, 1.0),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
          boxShadow: [
            BoxShadow(color: Colors.black, spreadRadius: 2, blurRadius: 7)
          ],
        ),
        child: Center(
          child: child,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return background(child: logo());
  }
}
