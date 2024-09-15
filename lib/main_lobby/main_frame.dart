import 'package:flutter/material.dart';
import 'package:portfolio/main_lobby/category.dart';
import 'package:portfolio/main_lobby/title_logo.dart';

class MainFrame extends StatefulWidget {
  MainFrame({super.key});

  @override
  State<MainFrame> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  final List<Map> categories = [
    {
      "title": "1테스트 카테고리",
      "description": "카테고리가 화면에 보이는 부분을 테스트하기 위한 테스트 데이터 입니다.",
      "path": "/test/",
    },
    {
      "title": "2테스트 카테고리",
      "description": "카테고리가 화면에 보이는 부분을 테스트하기 위한 테스트 데이터 입니다.",
      "path": "/test/",
    },
    {
      "title": "3테스트 카테고리",
      "description": "카테고리가 화면에 보이는 부분을 테스트하기 위한 테스트 데이터 입니다.",
      "path": "/test/",
    },
    {
      "title": "4테스트 카테고리",
      "description": "카테고리가 화면에 보이는 부분을 테스트하기 위한 테스트 데이터 입니다.",
      "path": "/test/",
    },
    {
      "title": "5테스트 카테고리",
      "description": "카테고리가 화면에 보이는 부분을 테스트하기 위한 테스트 데이터 입니다.",
      "path": "/test/",
    },
    {
      "title": "6테스트 카테고리",
      "description": "카테고리가 화면에 보이는 부분을 테스트하기 위한 테스트 데이터 입니다.",
      "path": "/test/",
    },
    {
      "title": "7테스트 카테고리",
      "description": "카테고리가 화면에 보이는 부분을 테스트하기 위한 테스트 데이터 입니다.",
      "path": "/test/",
    },
    {
      "title": "8테스트 카테고리",
      "description": "카테고리가 화면에 보이는 부분을 테스트하기 위한 테스트 데이터 입니다.",
      "path": "/test/",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TitleLogo(),
          Category(categories, width: MediaQuery.of(context).size.width),
        ],
      ),
    );
  }
}
