import 'package:flutter/material.dart';
import 'package:portfolio/main_page/category_list.dart';
import 'package:portfolio/main_page/info_tile.dart';
import 'package:portfolio/main_page/logo.dart';
import 'package:portfolio/main_page/recent_post_list.dart';
import 'package:portfolio/tool/color_list.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

class HambergerMenu extends StatefulWidget {
  final bool opacity;
  const HambergerMenu({super.key, this.opacity = true});

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
    double width = 300;
    return Stack(
      children: [
        OutBackground(active: open, onClick: switchOpen),
        SizedBox(
          height: double.infinity,
          width: width,
          child: Stack(
            children: [
              AnimatedPositioned(
                curve: Curves.easeOutQuart,
                duration: const Duration(milliseconds: 500),
                left: open ? 0 : -width,
                child: Contents(
                  width,
                  open: open,
                  opacity: widget.opacity,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child:
                    HambergerBtn(active: open, size: 25, trigger: switchOpen),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HambergerBtn extends StatefulWidget {
  final bool active;
  final double size;
  final void Function() trigger;

  const HambergerBtn({
    super.key,
    this.active = false,
    required this.size,
    required this.trigger,
  });

  @override
  State<HambergerBtn> createState() => _HambergerBtnState();
}

class _HambergerBtnState extends State<HambergerBtn> {
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
          turns: widget.active ? 0.25 : 0,
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
  final bool opacity;
  const Contents(
    this.width, {
    super.key,
    required this.open,
    this.opacity = true,
  });

  @override
  State<Contents> createState() => _ContentsState();
}

class _ContentsState extends State<Contents> {
  Widget part({
    required String title,
    required Widget child,
    bool koreanSize = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "< ",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 25,
                  fontFamily: "pixel",
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: koreanSize ? 20 : 25,
                  fontFamily: "pixel",
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                " >",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 25,
                  fontFamily: "pixel",
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.opacity ? Colors.black.withOpacity(0.4) : COLOR_GREEN,
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
              SideLogo(size: widget.width / 7 * 4),
              part(
                title: "INFO",
                child: InfoTile(active: widget.open),
              ),
              part(
                title: "카테고리",
                koreanSize: true,
                child: CategoryList(active: widget.open),
              ),
              part(
                title: "최근 게시물",
                koreanSize: true,
                child: RecentPostList(active: widget.open),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OutBackground extends StatefulWidget {
  final bool active;
  final void Function() onClick;
  const OutBackground({super.key, this.active = false, required this.onClick});

  @override
  State<OutBackground> createState() => _OutBackgroundState();
}

class _OutBackgroundState extends State<OutBackground> {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.active,
      child: GestureDetector(
        onTapUp: (details) {
          if (widget.active) widget.onClick();
        },
        child: AnimatedOpacity(
          opacity: widget.active ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            color: Colors.black.withOpacity(0.2),
          ),
        ),
      ),
    );
  }
}
