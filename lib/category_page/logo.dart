import 'package:flutter/material.dart';

class CateLogo extends StatefulWidget {
  final String title;
  final String description;
  const CateLogo({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  State<CateLogo> createState() => _CateLogoState();
}

class _CateLogoState extends State<CateLogo> {
  bool up = false;
  Duration animationDelay = const Duration(milliseconds: 1500);

  void animating() async {
    while (true) {
      await Future.delayed(animationDelay);
      setState(() {
        up = !up;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    animating();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: "pixel",
            fontWeight: FontWeight.bold,
            fontSize: 50,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          widget.description.replaceAll("\\n", " "),
          style: const TextStyle(
            color: Colors.white,
            fontFamily: "pixel",
            fontSize: 15,
          ),
        ),
        AnimatedContainer(
          duration: animationDelay,
          curve: Curves.easeInOut,
          height: up ? 10 : 0,
        ),
      ],
    );
  }
}
