import 'package:flutter/material.dart';

class FlexibleText extends StatelessWidget {
  final String txt;
  final int maxLine;
  final double width;
  final TextStyle textStyle;
  const FlexibleText(
    this.txt, {
    super.key,
    required this.width,
    required this.maxLine,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Row(
        children: [
          Flexible(
            child: RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: maxLine,
              text: TextSpan(
                text: txt,
                style: textStyle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
