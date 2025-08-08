import 'package:flutter/material.dart';
import 'package:portfolio/tool/color.dart';
import 'package:portfolio/views/main_page.dart';

void main() {
  runApp(const MainWidget());
}

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "조형구 포트폴리오",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: MyColor.primary),
      ),
      home: Scaffold(backgroundColor: MyColor.white, body: MainPage()),
    );
  }
}
