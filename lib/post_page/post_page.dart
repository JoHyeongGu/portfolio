import 'post_contents.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/base_data.dart';
import 'package:portfolio/tool/color_list.dart';
import 'package:portfolio/tool/tool_widgets.dart';
import 'package:portfolio/main_page/hamberger_menu.dart';

class PostPage extends StatefulWidget {
  final Map params;
  const PostPage(
    this.params, {
    super.key,
  });

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Map? data;
  double thumbnailWidth = double.infinity;
  double thumbnailHeight = 250;

  void getData() async {
    BaseData base = BaseData.of(context)!;
    Map? savedData = base.getData("post_data");
    if (savedData != null) {
      setState(() {
        data = savedData;
      });
    } else {
      String id = widget.params["id"][0];
      data = await base.db.getPostDataById(id);
      setState(() {});
    }
  }

  List<Widget> thumbnail() {
    return [
      SizedBox(
        width: thumbnailWidth,
        height: thumbnailHeight,
        child: data != null
            ? Image.network(
                data!["thumbnail"],
                fit: BoxFit.cover,
              )
            : const ColoredBox(
                color: Colors.white,
              ),
      ),
      Container(
        width: thumbnailWidth,
        height: thumbnailHeight,
        color: Colors.black.withOpacity(0.7),
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Center(
            child: Text(
              data != null ? data!["title"] : "",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: "pixel",
              ),
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> contents() {
    return [
      Container(
        margin: EdgeInsets.only(top: thumbnailHeight - 15),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(188, 173, 158, 1.0),
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        width: double.infinity,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              "(^-^) Hello, World!",
              style: TextStyle(
                fontFamily: "pixel",
                fontSize: 20,
                color: Colors.brown.withOpacity(0.8),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      smoothScroll(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.width - thumbnailHeight - 15,
          ),
          margin: EdgeInsets.only(top: thumbnailHeight),
          width: double.infinity,
          decoration: BoxDecoration(
            color: fixColorIvory,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.only(bottom: 50),
          child: data != null ? PostContents(data!) : null,
        ),
      ),
    ];
  }

  List<Widget> menu = [
    Container(
      height: 75,
      decoration: BoxDecoration(
        color: fixColorGreen.withOpacity(0.9),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
      ),
    ),
    const HambergerMenu(opacity: false),
  ];

  @override
  Widget build(BuildContext context) {
    if (data == null) getData();
    return Stack(
      children: [
        ...thumbnail(),
        ...contents(),
        ...menu,
      ],
    );
  }
}
