import 'package:flutter/material.dart';
import 'package:portfolio/main_lobby/category_list.dart';
import 'package:portfolio/main_lobby/logo.dart';
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
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 200),
            left: open ? 0 : -_width,
            child: Contents(_width, open: open),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: HambergerBtn(size: 19, trigger: switchOpen),
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
  List<Widget> logo() {
    return [
      SiteLogo(size: widget.width / 7 * 4),
      const SizedBox(height: 100),
    ];
  }

  List<Widget> category() {
    Widget title = Text(
      "카테고리",
      style: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 25,
        fontFamily: "pixel",
        letterSpacing: 0.2,
        fontWeight: FontWeight.bold,
      ),
    );
    return [
      Column(
        children: [
          title,
          SizedBox(height: 15),
          CategoryList(widget.open),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.4),
      width: widget.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: DynMouseScroll(
        durationMS : 500,
        scrollSpeed : 3,
        animationCurve : Curves.easeOutQuart,
        builder: (context, controller, physics) => SingleChildScrollView(
          controller: controller,
          physics: physics,
          child: Column(
            children: [
              const SizedBox(height: 70),
              ...logo(),
              ...category(),
            ],
          ),
        ),
      ),
    );
  }
}
