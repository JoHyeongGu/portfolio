import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/test_data.dart';
import 'package:portfolio/tool/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:portfolio/main_lobby/main_frame.dart';

void initFlutter() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };
}

Future<FirebaseApp> initFirebase() async {
  FirebaseApp app =
      await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  return app;
}

void main() async {
  initFlutter();
  Map metadata = {
    "firebase": await initFirebase(),
    "database": Database(),
  };
  runApp(MyApp(metadata));
}

class MyApp extends StatelessWidget {
  final Map metadata;
  const MyApp(this.metadata, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "조앤디어: 조씨의 좋은 아이디어 저장소",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      home: Scaffold(body: MainFrame(metadata)),
    );
  }
}
