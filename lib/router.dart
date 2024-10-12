import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/main_page/main_page.dart';
import 'package:portfolio/post_page/post_page.dart';

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
      '/category',
      handler: Handler(
        handlerFunc: (context, Map<String, dynamic> params) => Scaffold(
          body: TestWidget(params.toString()),
        ),
      ),
    );
    router.define(
      '/post',
      handler: Handler(
        handlerFunc: (context, Map<String, dynamic> params) => Scaffold(
          body: PostPage(params),
        ),
      ),
    );
  }

  static void navigateTo(BuildContext context, String route) {
    router.navigateTo(context, route, transition: TransitionType.material);
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
    return Text(widget.txt);
  }
}
