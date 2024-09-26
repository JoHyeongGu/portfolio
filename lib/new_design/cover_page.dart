import 'package:flutter/material.dart';
import 'package:portfolio/main_lobby/title_logo.dart';
import 'package:portfolio/tool/color_list.dart';

class CoverPage extends StatefulWidget {
  const CoverPage({super.key});

  @override
  State<CoverPage> createState() => _CoverPageState();
}

class _CoverPageState extends State<CoverPage> {
  Container cover = Container(
    color: BACKGROUND_COLOR,
    child: Center(
      child: TitleLogo(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    print("Cover Page 빌드!");
    return Stack(
      children: [
        cover,
      ],
    );
  }
}
