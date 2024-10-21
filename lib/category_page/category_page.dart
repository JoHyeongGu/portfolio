import 'package:flutter/material.dart';
import 'package:portfolio/base_data.dart';
import 'package:portfolio/category_page/logo.dart';
import 'package:portfolio/tool/color_list.dart';
import 'package:portfolio/main_page/hamberger_menu.dart';

class CategoryPage extends StatefulWidget {
  final Map<String, dynamic> params;
  const CategoryPage(this.params, {super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  Map? data;
  List<Map> postList = [];

  void getData() async {
    BaseData base = BaseData.of(context)!;
    Map? savedData = base.getData("cate_data");
    if (savedData != null) {
      data = savedData;
    } else {
      String path = widget.params["type"][0];
      data = await base.db.getCategoryByPath(path);
    }
    setState(() {});
    if (data != null) {
      postList = await base.db.getPostListByCategoryId(data!["id"]);
      setState(() {});
    }
  }

  Widget background() {
    return Container(
      color: Colors.black,
      width: double.infinity,
      height: double.infinity,
      child: data != null
          ? Opacity(
              opacity: 0.6,
              child: Image.network(
                data!["thumbnail"],
                fit: BoxFit.cover,
              ),
            )
          : null,
    );
  }

  Widget content() {
    if (data == null) {
      return const Center(
        child: Text(
          "no data.",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      );
    }
    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: CateLogo(
              title: data!["title"],
              description: data!["description"],
            ),
          ),
        ),
        AnimatedContainer(
          curve: Curves.decelerate,
          duration: Duration(seconds: 1),
          height: double.infinity,
          width: postList.isNotEmpty
              ? MediaQuery.of(context).size.width * (3 / 4)
              : 0,
          color: Colors.black.withOpacity(0.3),
        ),
      ],
    );
  }

  List<Widget> menu = [
    Container(
      height: 75,
      decoration: BoxDecoration(
        color: fixColorGreen.withOpacity(0.6),
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
        background(),
        content(),
        ...menu,
      ],
    );
  }
}
