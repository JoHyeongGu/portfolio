import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/main_lobby/main_frame.dart';

class WebRouter {
  static FluroRouter router = FluroRouter();

  static final Handler mainLobby = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => Scaffold());
  static final Handler _Test2 = Handler(
    handlerFunc: (context, Map<String, dynamic> params) =>
        Center(child: Text(params.toString())),
  );
  static final Handler _Test3 = Handler(
    handlerFunc: (context, Map<String, dynamic> params) =>
        Center(child: Text("Big One")),
  );

  static void defineRoutes() {
    router.define(
      '/',
      handler: mainLobby,
    );
    router.define(
      '/test2',
      handler: _Test2,
    );
    router.define(
      '/test2',
      handler: _Test2,
    );
  }

  static void navigateTo(BuildContext context, String route) {
    router.navigateTo(context, route, transition: TransitionType.fadeIn);
  }
}
