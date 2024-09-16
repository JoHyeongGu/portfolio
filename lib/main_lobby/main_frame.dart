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
      "title": "0테스트 카테고리",
      "description": "카테고리가 화면에 보이는 부분을 테스트하기 위한 테스트 데이터 입니다.",
      "path": "/test/",
    },
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
          const SizedBox(height: 30),
          Category(categories, outPadding: contentPadding),
          const PostList(),
        ],
      ),
    );
  }
}

class PostList extends StatelessWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Container(
            width: 300,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: const Border(
                top: BorderSide(color: Colors.black, width: 2),
                left: BorderSide(color: Colors.black, width: 2),
                right: BorderSide(color: Colors.black, width: 2),
                bottom: BorderSide(color: Colors.black, width: 2),
              ),
            ),
          )
        ],
      ),
    );
  }
}
