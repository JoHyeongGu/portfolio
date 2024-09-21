import 'package:flutter/material.dart';
import 'package:portfolio/tool/color_list.dart';

class RecentPostList extends StatelessWidget {
  RecentPostList({super.key});

  BoxDecoration boxDecoration = BoxDecoration(
    color: BACKGROUND_COLOR,
    border: Border.all(
      color: Colors.brown.withOpacity(0.8),
    ),
    borderRadius: BorderRadius.circular(15),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 17),
            height: 500,
            decoration: boxDecoration,
          ),
          SizedBox(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 100),
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 30),
              decoration: boxDecoration,
              child: Center(
                child: Text(
                  "최근 게시물",
                  style: TextStyle(
                    fontSize: 23,
                    fontFamily: "leeseoyoon",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
