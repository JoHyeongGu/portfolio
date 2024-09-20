import 'package:flutter/material.dart';
import 'package:portfolio/main_lobby/main_frame.dart';
import 'package:portfolio/test_data.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };
  Map data = testData;
  runApp(MyApp(data));
}

class MyApp extends StatelessWidget {
  final Map data;
  const MyApp(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JoNdea',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      home: Scaffold(body: MainFrame(data)),
    );
  }
}
