import 'package:flutter/material.dart';
import 'package:portfolio/widgets/widgets.dart';

class SkillCard extends StatefulWidget {
  final String title;
  final Color color;
  const SkillCard({super.key, required this.title, required this.color});

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Image.asset(
                "assets/images/flutter_logo.png",
                width: 17,
                color: Colors.black.withValues(alpha: 0.7),
              ),
              Image.asset(
                "assets/images/flutter_logo.png",
                width: 16,
                color: Colors.white,
              ),
            ],
          ),
          SizedBox(width: 5),
          BasicText(
            widget.title,
            size: 14,
            color: Colors.white,
            weight: FontWeight.w500,
            shadow: Shadow(color: Colors.black, blurRadius: 2),
          ),
        ],
      ),
    );
  }
}
