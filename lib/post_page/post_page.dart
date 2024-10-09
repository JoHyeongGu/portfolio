import 'package:flutter/material.dart';
import 'package:portfolio/base_data.dart';
import 'package:portfolio/main_page/hamberger_menu.dart';
import 'package:portfolio/tool/color_list.dart';
import 'package:portfolio/tool/tool_widgets.dart';

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
        // child: const Loading(
        //   alignment: Alignment.topCenter,
        //   edgeInsets: EdgeInsets.only(top: 30),
        //   color: Colors.brown,
        // ),
      ),
      smoothScroll(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.width - thumbnailHeight - 15,
          ),
          margin: EdgeInsets.only(top: thumbnailHeight),
          width: double.infinity,
          decoration: BoxDecoration(
            color: COLOR_IVORY,
            borderRadius: BorderRadius.circular(15),
          ),
          child: data != null ? PostContents(data!["content"]) : Container(),
        ),
      ),
    ];
  }

  List<Widget> menu = [
    Container(
      height: 75,
      decoration: BoxDecoration(
        color: COLOR_GREEN.withOpacity(0.9),
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

class PostContents extends StatelessWidget {
  final String contents;
  const PostContents(this.contents, {super.key});

  Widget text(String c) {
    return Text(
      c,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 15,
      ),
    );
  }

  Widget image(String c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Image.network(c.replaceAll("<img>", "")),
    );
  }

  Widget code(String c) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 45),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Theme(
        data: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
            selectionColor: Colors.green,
          ),
        ),
        child: SelectableText(
          c.replaceAll("<code>", "").replaceAll("\\n", "\n"),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget token(String c) {
    if (c.contains("<img>")) {
      return image(c);
    } else if (c.contains("<code>")) {
      return code(c);
    } else {
      return text(c);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 10,
      ),
      child: Column(
        children: contents.split("<n>").map((c) => token(c)).toList(),
      ),
    );
  }
}
