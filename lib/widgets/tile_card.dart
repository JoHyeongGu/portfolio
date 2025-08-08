import 'package:flutter/material.dart';
import 'package:portfolio/tool/tool.dart';

class TileCard extends StatefulWidget {
  final double width;
  final double height;
  final EdgeInsets? margin;
  const TileCard({
    super.key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.margin,
  });

  @override
  State<TileCard> createState() => _TileCardState();
}

class _TileCardState extends State<TileCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: MyColor.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      margin: widget.margin,
    );
  }
}
