import 'package:flutter/material.dart';
import 'package:portfolio/tool/color_list.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  BoxDecoration boxDecoration = BoxDecoration(
    color: BACKGROUND_COLOR,
    border: Border.all(
      color: Colors.brown.withOpacity(0.8),
    ),
    borderRadius: BorderRadius.circular(15),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 17),
          width: 270,
          height: 500,
          decoration: boxDecoration,
        ),
        SizedBox(
          width: 270,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 60),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 30),
            decoration: boxDecoration,
            child: Center(
              child: Text(
                "프로필",
                style: TextStyle(
                  fontSize: 23,
                  fontFamily: "leeseoyoon",
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
