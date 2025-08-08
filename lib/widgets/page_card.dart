import 'package:flutter/material.dart';
import 'package:portfolio/tool/color.dart';

class PageCard extends StatefulWidget {
  final Widget? child;
  final Widget? inner;
  final double width;
  final double height;
  final Color background;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BorderRadiusGeometry? radius;
  final double shadow;
  const PageCard({
    super.key,
    this.background = MyColor.white,
    this.width = double.infinity,
    this.height = double.infinity,
    this.shadow = 0.2,
    this.child,
    this.inner,
    this.margin,
    this.padding,
    this.radius,
  });

  @override
  State<PageCard> createState() => _PageCardState();
}

class _PageCardState extends State<PageCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.background,
        borderRadius:
            widget.radius ?? BorderRadius.vertical(bottom: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: MyColor.brown.withValues(alpha: widget.shadow),
            blurRadius: 10,
            spreadRadius: 0.1,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: widget.child,
    );
  }
}
