import 'package:flutter/material.dart';
import 'hamberger_menu.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget background = Container(
    color: const Color.fromRGBO(30, 43, 37, 1.0),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        background,
        const HambergerMenu(),
      ],
    );
  }
}
