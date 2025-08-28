import 'package:flutter/material.dart';
import 'package:portfolio/tool/tool.dart';
import 'package:portfolio/views/views.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late ScrollController scrollController;
  late PageController pageController;
  bool ignore = false;

  initController() {
    pageController = PageController();
    scrollController = ScrollController(initialScrollOffset: 10);
    pageController.addListener(
      () => setState(() {
        ignore = pageController.page! >= 1.0;
      }),
    );
    scrollController.addListener(
      () => setState(() {
        if (!ignore) {
          scrollController.jumpTo(10);
        }
        ignore = scrollController.offset >= 5;
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    initController();
  }

  @override
  void dispose() {
    pageController.dispose();
    scrollController.dispose();
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
        backgroundColor: MyColor.background,
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: scrollController,
              child: Column(children: [AboutPage()]),
            ),
            IgnorePointer(
              ignoring: ignore,
              child: PageView(
                controller: pageController,
                scrollDirection: Axis.vertical,
                children: [TitlePage(pageController), Container()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
