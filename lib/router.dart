import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/main_lobby/main_page.dart';

class WebRouter {
  static FluroRouter router = FluroRouter();

  static Handler Page({required Widget child}) {
    return Handler(
      handlerFunc: (context, Map<String, dynamic> params) => Scaffold(
        body: child,
      ),
    );
  }

  static void defineRoutes() {
    router.define(
      '/',
      handler: Page(child: MainPage()),
    );
    router.define(
      '/test',
      handler: Page(child: TestWidget()),
    );
  }

  static void navigateTo(BuildContext context, String route) {
    router.navigateTo(context, route, transition: TransitionType.fadeIn);
  }
}

class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    print("Test 위젯 빌드!!");
    return Text("Test");
  }
}
