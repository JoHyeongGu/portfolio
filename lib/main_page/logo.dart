import 'package:flutter/material.dart';

class SiteLogo extends StatelessWidget {
  final double size;
  const SiteLogo({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 70),
      child: Image.asset(
        "assets/pixel_logo.png",
        width: size,
      ),
    );
  }
}
