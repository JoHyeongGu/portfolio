import 'package:fluro/fluro.dart';
import 'package:portfolio/base_data.dart';
import 'package:portfolio/tool/color_list.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/router.dart';
import 'package:portfolio/tool/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:portfolio/main_lobby/main_frame.dart';

void initFlutter() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };
  setPathUrlStrategy();
  WebRouter.defineRoutes();
}

Future<FirebaseApp> initFirebase() async {
  FirebaseApp app =
      await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  return app;
}

void main() async {
  initFlutter();
  FirebaseApp firebase = await initFirebase();
  Database database = Database();
  runApp(MyApp(firebase, database));
}

class MyApp extends StatelessWidget {
  final FirebaseApp firebase;
  final Database database;
  const MyApp(this.firebase, this.database, {super.key});

  @override
  Widget build(BuildContext context) {
    return BaseData(
      firebase: firebase,
      db: database,
      child: MaterialApp(
        title: "조앤디어: 조씨의 좋은 아이디어 저장소",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: BANNER_COLOR),
          useMaterial3: true,
        ),
        // onGenerateRoute: WebRouter.router.generator,
        // initialRoute: "/",
        home: Scaffold(body: MainPage()),
      ),
    );
  }
}
