import 'package:flutter/material.dart';
import 'package:portfolio/base_data.dart';
import 'package:portfolio/main_page/hamberger_menu.dart';
import 'package:portfolio/tool/color_list.dart';

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

  void getData() async {
    if (data != null) return;
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

  Widget contents() {
    if (data == null) {
      return const Center(
        child: Text("데이터 불러오는 중..."),
      );
    }
    double titleHeight = 250;
    Widget title = SizedBox(
      height: 250,
      width: double.infinity,
      child: Stack(
        children: [
          SizedBox(
            height: 250,
            width: double.infinity,
            child: Image.network(
              data!["thumbnail"],
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
            height: 250,
            width: double.infinity,
            color: Colors.black.withOpacity(0.7),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 50,
              left: 50,
              right: 50,
            ),
            child: Center(
              child: Text(
                data!["title"],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          title,
          Container(
            height: 1000,
            color: COLOR_IVORY,
          )
        ],
      ),
    );
  }

  Widget top = Container(
    decoration: BoxDecoration(
      color: COLOR_GREEN,
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(15),
      ),
    ),
    height: 80,
    width: double.infinity,
  );

  @override
  Widget build(BuildContext context) {
    getData();
    return Stack(
      children: [
        contents(),
        top,
        const HambergerMenu(opacity: false),
      ],
    );
  }
}
