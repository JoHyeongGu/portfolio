import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final Alignment alignment;
  final EdgeInsets edgeInsets;
  final Color color;
  const Loading({
    super.key,
    this.alignment = Alignment.center,
    this.edgeInsets = EdgeInsets.zero,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: edgeInsets,
        child: CircularProgressIndicator(
          color: color,
        ),
      ),
    );
  }
}
