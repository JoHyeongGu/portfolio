import 'package:flutter/material.dart';
import 'package:portfolio/tool/FlexibleText.dart';
import 'package:portfolio/tool/color_list.dart';

class RecentPostList extends StatelessWidget {
  final List<Map> posts;
  RecentPostList(this.posts, {super.key});

  BoxDecoration boxDecoration = BoxDecoration(
    color: BACKGROUND_COLOR,
    border: Border.all(
      color: Colors.brown.withOpacity(0.8),
    ),
    borderRadius: BorderRadius.circular(15),
  );

  Widget title() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 100),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 30),
      decoration: boxDecoration,
      child: const Center(
        child: Text(
          "최근 게시물",
          style: TextStyle(
            fontSize: 23,
            fontFamily: "leeseoyoon",
          ),
        ),
      ),
    );
  }

  Widget frame({required Widget child}) {
    return Stack(
      children: [
        Container(
          height: 500,
          decoration: boxDecoration,
          margin: const EdgeInsets.only(top: 17),
          padding: const EdgeInsets.only(top: 30),
          child: child,
        ),
        title(),
      ],
    );
  }

  Widget content() {
    return Column(
      children: posts
          .map(
            (p) => Post(p),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * (3 / 5),
      child: Padding(
        padding: const EdgeInsets.only(left: 18),
        child: frame(child: content()),
      ),
    );
  }
}

class Post extends StatelessWidget {
  final Map data;
  final Size thumbnailSize = const Size(191, 100);
  const Post(this.data, {super.key});

  Widget thumbnail() {
    return Container(
      width: thumbnailSize.width,
      height: thumbnailSize.height,
      margin: const EdgeInsets.only(right: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          data["thumbnail"],
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  Widget textZone(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FlexibleText(
          data["title"],
          width: 300,
          maxLine: 1,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        FlexibleText(
          data["content"],
          width: 300,
          maxLine: 2,
          textStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          thumbnail(),
          textZone(context),
        ],
      ),
    );
  }
}
