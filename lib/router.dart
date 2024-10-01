import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/main_lobby/main_page.dart';

class WebRouter {
  static FluroRouter router = FluroRouter();

  static void defineRoutes() {
    router.define(
      '/',
      handler: Handler(
        handlerFunc: (context, Map<String, dynamic> params) => const Scaffold(
          body: MainPage(),
        ),
      ),
    );
    router.define(
      '/test',
      handler: Handler(
        handlerFunc: (context, Map<String, dynamic> params) => Scaffold(
          body: TestWidget(params.toString()),
        ),
      ),
    );
  }

  static void navigateTo(BuildContext context, String route) {
    router.navigateTo(context, route, transition: TransitionType.fadeIn);
  }
}

class TestWidget extends StatefulWidget {
  final String txt;
  const TestWidget(this.txt, {super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    print("Test 위젯 빌드!!");
    return Text(widget.txt);
  }
}
