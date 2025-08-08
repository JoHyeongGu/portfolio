import 'package:flutter/material.dart';
import 'package:portfolio/tool/tool.dart';
import 'package:portfolio/views/views.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "조형구 포트폴리오",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: MyColor.primary),
      ),
      home: Scaffold(
        backgroundColor: MyColor.white,
        body: PageView(
          controller: pageController,
          scrollDirection: Axis.vertical,
          children: [TitlePage(pageController), MenuPage()],
        ),
      ),
    );
  }
}
