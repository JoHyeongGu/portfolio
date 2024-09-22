import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/main_lobby/main_frame.dart';
import 'package:portfolio/test_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void initFlutter() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };
}

Future<void> initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
}

void main() async {
  initFlutter();
  await initFirebase();
  Map data = testData;
  runApp(MyApp(data));
}

class MyApp extends StatelessWidget {
  final Map data;
  const MyApp(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "조앤디어: 조씨의 좋은 아이디어 저장소",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      home: Scaffold(body: MainFrame(data)),
    );
  }
}
