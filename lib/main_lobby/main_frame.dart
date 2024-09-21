import 'package:flutter/material.dart';
import 'package:portfolio/main_lobby/post_list/recent_post_list.dart';
import 'package:portfolio/main_lobby/profile.dart';
import 'package:portfolio/main_lobby/title_logo.dart';
import 'package:portfolio/main_lobby/categories/animated_category_list.dart';
import 'package:portfolio/tool/color_list.dart';

class MainFrame extends StatefulWidget {
  final Map data;

  const MainFrame(this.data, {super.key});

  @override
  State<MainFrame> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  Size contentPadding = const Size(60, 45);

  Widget categories() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: AnimatedCategoryList(
        widget.data["categories"],
        outPadding: contentPadding.width,
      ),
    );
  }

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
              categories(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Profile(),
                  Flexible(child: RecentPostList()),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: BACKGROUND_COLOR,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TitleLogo(),
            contents(),
            Container(
              color: PAGE_END_COLOR,
              height: 150,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Text(
                    "DEV_BY_JOHYEONGGU",
                    style: TextStyle(
                      wordSpacing: 0.2,
                      color: Colors.white,
                      fontFamily: "pixel",
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
