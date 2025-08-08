import 'package:flutter/material.dart';
import 'package:portfolio/tool/color.dart';

class BasicText extends StatelessWidget {
  final String txt;
  final double size;
  final String family;
  final Color color;
  final FontWeight weight;
  final bool italic;
  final TextDecoration? line;
  const BasicText(
    this.txt, {
    super.key,
    this.family = "paperlogy",
    this.size = 12,
    this.color = MyColor.black,
    this.weight = FontWeight.normal,
    this.italic = false,
    this.line,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
        fontFamily: family,
        color: color,
        fontWeight: weight,
        fontSize: size,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        decoration: line,
      ),
    );
  }
}
