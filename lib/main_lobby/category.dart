import 'package:flutter/material.dart';

class Category extends StatefulWidget {
  const Category(this.categories, {super.key, this.outPadding = 0});
  final List<Map> categories;
  final double outPadding;

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  double gap = 40;
  double tileWidth = 300;
  double tileHeight = 400;
  double innerPadding = 0;
  int screenCount = 0;
  late int focus;

  void initWithSize() {
    screenCount = (MediaQuery.of(context).size.width / tileWidth).toInt();
    if (screenCount % 2 == 0) screenCount--;
    innerPadding = MediaQuery.of(context).size.width / 10;
  }

  void autoScroll() async {
    while (true) {
      await Future.delayed(Duration(seconds: 3));
      focus++;
      if (focus >= widget.categories.length) focus = 0;
      setState(() {});
    }
  }

  double getCenterPos() {
    return (MediaQuery.of(context).size.width / 2) -
        (tileWidth / 2) -
        (widget.outPadding + innerPadding);
  }

  Widget animatedTile(Map cate) {
    double centerPos = getCenterPos();
    double pos = screenCount == 0
        ? centerPos
        : centerPos + (tileWidth + gap) * (cate["index"] - focus);
    return AnimatedPositioned(
      curve: Curves.easeInBack,
      duration: Duration(milliseconds: 700 + (cate["index"] * 40).toInt() as int),
      left: pos,
      child: CategoryTile(
        cate,
        width: tileWidth,
        height: tileHeight,
      ),
    );
  }

  Widget animatedCategories() {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(horizontal: innerPadding),
      child: Stack(
        children: widget.categories.map((cate) => animatedTile(cate)).toList(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.categories.length % 2 == 0) {
      widget.categories.add({});
    }
    for (MapEntry cate in widget.categories.asMap().entries) {
      cate.value["index"] = cate.key;
    }
    focus = widget.categories.length ~/ 2;
    autoScroll();
  }

  @override
  Widget build(BuildContext context) {
    initWithSize();
    return SizedBox(
      width: double.infinity,
      height: tileHeight,
      child: animatedCategories(),
    );
  }
}

class CategoryTile extends StatefulWidget {
  const CategoryTile(this.data,
      {super.key, this.width = 300, this.height = 400, this.detail});
  final Map data;
  final bool? detail;
  final double width;
  final double height;

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  bool onDetail = true;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (var event) {
        setState(() {
          // onDetail = true;
        });
      },
      onExit: (var event) {
        setState(() {
          // onDetail = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          print(widget.data["path"]);
        },
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(15),
          ),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: onDetail ? 1 : 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(15),
              ),
              height: widget.width,
              child: Column(
                children: [
                  Text(widget.data.keys.toList().contains("title")
                      ? widget.data["title"]
                      : ""),
                  Text(widget.data.keys.toList().contains("description")
                      ? widget.data["description"]
                      : ""),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
