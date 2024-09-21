import 'package:flutter/material.dart';
import 'package:portfolio/main_lobby/title_logo.dart';
import 'package:portfolio/main_lobby/categories/animated_category_list.dart';

class MainFrame extends StatefulWidget {
  final Map data;

  const MainFrame(this.data, {super.key});

  @override
  State<MainFrame> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  Size contentPadding = const Size(60, 45);

  Widget contents() {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: contentPadding.width,
            vertical: contentPadding.height,
          ),
          child: Column(
            children: [
              AnimatedCategoryList(
                widget.data["categories"],
                outPadding: contentPadding.width,
              ),
              Container(height: 500),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(248, 234, 215, 1.0),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                TitleLogo(),
                contents(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
