import 'package:flutter/material.dart';
import 'package:portfolio/tool/color_list.dart';
import 'hamberger_menu.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget background = Container(
    color: COLOR_GREEN,
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
