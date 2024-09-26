import 'package:flutter/material.dart';
import 'package:portfolio/tool/database.dart';
import 'package:firebase_core/firebase_core.dart';

class BaseData extends InheritedWidget {
  final FirebaseApp firebase;
  final Database db;
  final Map<String, dynamic> savedData = {};

  BaseData({
    super.key,
    required super.child,
    required this.firebase,
    required this.db,
  });

  static BaseData? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BaseData>();

  void saveData(String key, dynamic value) {
    savedData[key] = value;
  }

  dynamic getData(String key) {
    return savedData[key];
  }

  @override
  bool updateShouldNotify(BaseData oldWidget) => false;
}
