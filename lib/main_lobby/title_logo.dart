import 'package:flutter/material.dart';
import 'dart:html';

class TitleLogo extends StatelessWidget {
  TitleLogo({super.key});

  Widget thinkingHat = Image.asset("thinking_hat.png", height: 100);

  Widget bigTitle = const Text(
    "JO'NDEA",
    style: TextStyle(
      fontSize: 40,
      letterSpacing: 5,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: "leeseoyoon",
    ),
  );

  Widget smallTitle = const Text(
    "조씨의 좋은 아이디어 저장소",
    style: TextStyle(
      fontSize: 15,
      color: Colors.white,
      fontFamily: "leeseoyoon",
      letterSpacing: 0.8,
    ),
  );

  Widget logo() {
    return GestureDetector(
      onTap: () {
        window.location.reload();
      },
      child: SizedBox(
        width: 285,
        height: 100,
        child: Stack(
          children: [
            Positioned(child: thinkingHat),
            Positioned(top: 10, right: 0, child: bigTitle),
            Positioned(bottom: 20, right: 0, child: smallTitle),
          ],
        ),
      ),
    );
  }

  Widget background({Widget? child}) => Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(98, 113, 104, 1.0),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
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
