import 'package:flutter/material.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

Widget loadingWidget({
  Alignment alignment = Alignment.center,
  EdgeInsets edgeInsets = EdgeInsets.zero,
  Color color = Colors.white,
}) {
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

Widget smoothScroll({required Widget child}) {
  return DynMouseScroll(
    builder: (context, controller, physics) => SingleChildScrollView(
      controller: controller,
      physics: physics,
      child: child,
    ),
  );
}
