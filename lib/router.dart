import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/test_data.dart';
import 'package:portfolio/main_lobby/main_frame.dart';
import 'package:portfolio/new_design/cover_page.dart';

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
      handler: Page(child: CoverPage()),
    );
    router.define(
      '/old',
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
