import 'package:flutter/material.dart';

class SiteLogo extends StatelessWidget {
  final double size;
  const SiteLogo({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/pixel_logo.png",
      width: size,
    );
  }
}
