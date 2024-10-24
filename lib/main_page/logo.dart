import 'package:flutter/material.dart';
import 'package:portfolio/router.dart';

class SideLogo extends StatelessWidget {
  final double size;
  const SideLogo({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 70),
      child: GestureDetector(
        onTapUp: (details) {
          WebRouter.navigateTo(context, "/");
        },
        child: Image.asset(
          "assets/pixel_logo.png",
          width: size,
        ),
      ),
    );
  }
}

class MainLogo extends StatefulWidget {
  const MainLogo({super.key});

  @override
  State<MainLogo> createState() => _MainLogoState();
}

class _MainLogoState extends State<MainLogo> {
  bool padding = false;

  void animating() async {
    while (true) {
      setState(() {
        padding = !padding;
      });
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  @override
  void initState() {
    super.initState();
    animating();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: AnimatedPadding(
        curve: Curves.easeInOut,
        duration: const Duration(seconds: 1),
        padding: padding ? const EdgeInsets.only(top: 10) : EdgeInsets.zero,
        child: Image.asset(
          "assets/main_text_logo.png",
          width: 200,
        ),
      ),
    );
  }
}
