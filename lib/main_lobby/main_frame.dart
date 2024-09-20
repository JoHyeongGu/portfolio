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
  Size contentPadding = const Size(100, 45);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: contentPadding.width,
          vertical: contentPadding.height,
        ),
        child: Column(
          children: [
            const TitleLogo(),
            AnimatedCategoryList(widget.data["categories"], outPadding: contentPadding.width),
          ],
        ),
      ),
    );
  }
}
