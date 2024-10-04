import 'package:flutter/material.dart';
import 'package:portfolio/main_page/category_list.dart';
import 'package:portfolio/main_page/info_tile.dart';
import 'package:portfolio/main_page/logo.dart';
import 'package:portfolio/main_page/recent_post_list.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

class HambergerMenu extends StatefulWidget {
  const HambergerMenu({super.key});

  @override
  State<HambergerMenu> createState() => _HambergerMenuState();
}

class _HambergerMenuState extends State<HambergerMenu> {
  bool open = false;

  void switchOpen() {
    setState(() {
      open = !open;
    });
  }

  @override
  Widget build(BuildContext context) {
    double _width = 300;
    return SizedBox(
      height: double.infinity,
      width: _width,
      child: Stack(
        children: [
          AnimatedPositioned(
            curve: Curves.easeOutQuart,
            duration: const Duration(milliseconds: 500),
            left: open ? 0 : -_width,
            child: Contents(_width, open: open),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: HambergerBtn(size: 25, trigger: switchOpen),
          ),
        ],
      ),
    );
  }
}

class HambergerBtn extends StatefulWidget {
  final double size;
  final void Function() trigger;

  HambergerBtn({
    super.key,
    required this.size,
    required this.trigger,
  });

  @override
  State<HambergerBtn> createState() => _HambergerBtnState();
}

class _HambergerBtnState extends State<HambergerBtn> {
  bool turn = false;
  Color color = Colors.white.withOpacity(0.5);

  Widget stick() {
    return Container(
      width: double.infinity,
      height: widget.size / 5,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) => setState(() {
        turn = !turn;
        color = Colors.white.withOpacity(0.5);
        widget.trigger();
      }),
      onTapDown: (details) => setState(() {
        color = Colors.grey.withOpacity(0.5);
      }),
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(10),
        child: AnimatedRotation(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          turns: turn ? 0.25 : 0,
          child: SizedBox(
            width: widget.size + 5,
            height: widget.size,
            child: Column(
              children: [
                stick(),
                SizedBox(height: widget.size / 5),
                stick(),
                SizedBox(height: widget.size / 5),
                stick(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Contents extends StatefulWidget {
  final bool open;
  final double width;
  const Contents(this.width, {super.key, required this.open});

  @override
  State<Contents> createState() => _ContentsState();
}

class _ContentsState extends State<Contents> {
  Widget info() {
    Widget title = Text(
      "< INFO >",
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
        fontSize: 25,
        fontFamily: "pixel",
        letterSpacing: 0.2,
        fontWeight: FontWeight.bold,
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(top: 70, bottom: 40),
      child: Column(
        children: [
          title,
          const SizedBox(height: 10),
          InfoTile(widget.open),
        ],
      ),
    );
  }

  Widget category() {
    Widget title = Text(
      "< 카테고리 >",
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
        fontSize: 22,
        fontFamily: "pixel",
        letterSpacing: 0.2,
        fontWeight: FontWeight.bold,
      ),
    );
    return Column(
      children: [
        title,
        const SizedBox(height: 15),
        CategoryList(widget.open),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.4),
      width: widget.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: DynMouseScroll(
        durationMS: 1000,
        scrollSpeed: 1,
        animationCurve: Curves.easeOutQuart,
        builder: (context, controller, physics) => SingleChildScrollView(
          controller: controller,
          physics: physics,
          child: Column(
            children: [
              const SizedBox(height: 70),
              SiteLogo(size: widget.width / 7 * 4),
              info(),
              category(),
              if (widget.open) RecentPostList(),
            ],
          ),
        ),
      ),
    );
  }
}
