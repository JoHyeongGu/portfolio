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
      "title": "Hobby",
      "description": "음악과 그림 등 취미활동들을 저장하는 곳",
      "path": "/test/",
    },
    {
      "title": "Python",
      "description": "Python 언어의 기초 문법을 정리하고 Python을 활용하여 만든 알고리즘들을 탐구하는 곳",
      "path": "/test/",
    },
    {
      "title": "Flutter",
      "description": "Dart 언어의 기초 문법을 정리하고\nFlutter를 활용하여 만든 Web&App을 저장하는 곳",
      "path": "/test/",
    },
    {
      "title": "Server Deploy",
      "description": "서버와 관련된 기초 지식들을 정리하고 서버\n배포 과정 중 경함한 내용들을 저장하는 곳",
      "path": "/test/",
    },
    {
      "title": "Unity",
      "description": "Unity tool을 이용하여 게임을 만들며 생긴 이슈들을 정리하고 게임 개발의 기초를 다지는 곳",
      "path": "/test/",
    },
    {
      "title": "3D Modeling",
      "description": "3D 캐릭터를 모델링하는 방법을 탐구하고 과정 중 생긴 이슈들을 저장하는 곳",
      "path": "/test/",
    },
    {
      "title": "Idea Pictures",
      "description": "머릿 속에 떠오르는 아이디어들을 저장하는 곳",
      "path": "/test/",
    },
    {
      "title": "Windows",
      "description": "윈도우 OS 이용 중 발생한 이슈들을 다뤘던\n경험들을 저장하는 곳",
      "path": "/test/",
    },
    {
      "title": "Crawling",
      "description": "웹 상의 데이터를 가져오는 프로세스를\n구성하며 생긴 정보들을 저장하는 곳",
      "path": "/test/",
    },
  ];
  double contentPadding = 10;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(contentPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TitleLogo(),
          const SizedBox(height: 50),
          Category(categories, outPadding: contentPadding),
        ],
      ),
    );
  }
}
