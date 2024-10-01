import 'package:flutter/material.dart';
import 'package:portfolio/base_data.dart';
import 'package:portfolio/tool/color_list.dart';

class CategoryList extends StatefulWidget {
  final bool open;
  const CategoryList(this.open, {super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<Map> data = [];
  int autoCount = 0;
  int focus = 0;
  Size size = const Size(170, 200);
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void getData() async {
    if (widget.open && data.isEmpty) {
      data = await BaseData.of(context)!.db.getCategoryList();
    }
    setState(() {});
    if (autoCount == 0 && widget.open && data.isNotEmpty) {
      await Future.delayed(const Duration(seconds: 1));
      autoScroll();
    }
  }

  void autoScroll() async {
    if (data.isEmpty) return;
    autoCount++;
    while (true) {
      if (autoCount > 1 || !widget.open) {
        autoCount--;
        break;
      }
      _controller.animateTo(
        (size.width + 15) * (focus + 1),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
      if (autoCount > 1 || !widget.open) {
        autoCount--;
        break;
      }
      focus++;
      if (focus >= data.length) focus = 0;
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  Widget tile({Map? data, bool isData = true}) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 15),
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            color: BANNER_COLOR,
            borderRadius: BorderRadius.circular(15),
          ),
          child: isData
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    data!["thumbnail"],
                    fit: BoxFit.cover,
                  ),
                )
              : Opacity(
                  opacity: 0.7,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Center(
                      child: Image.asset("assets/thinking_hat.png"),
                    ),
                  ),
                ),
        ),
        Container(
          width: size.width,
          height: size.height,
          color: Colors.black.withOpacity(0.2),
        ),
        if (isData)
          SizedBox(
            width: size.width,
            height: size.height,
            child: Center(
              child: Text(
                data!["title"].toString().replaceAll(" ", "\n"),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "pixel",
                  fontSize: 35,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget cateText(Map data) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: MouseRegion(
        onEnter: (details) {},
        child: Text(
          data["title"],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: "dangdang",
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _controller,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                tile(isData: false),
                ...data.map((d) => tile(data: d)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        ...data.map((d) => cateText(d)),
      ],
    );
  }
}
