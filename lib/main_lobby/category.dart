import 'package:flutter/material.dart';

class Category extends StatefulWidget {
  const Category(this.categories, {super.key, this.outPadding = 0});
  final List<Map> categories;
  final double outPadding;

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  Size size = const Size(300, 400);
  double gap = 40;
  int screenCount = 0;
  late int focus;

  void initWithSize() {
    screenCount = (MediaQuery.of(context).size.width / size.width).toInt();
    if (screenCount % 2 == 0) screenCount--;
  }

  void resetIndex() {
    for (Map cate in widget.categories) {
      cate["index"] -= focus;
    }
    focus = 0;
    setState(() {});
  }

  void autoScroll() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 3));
      focus++;
      if (focus >= widget.categories.length) resetIndex();
      setState(() {});
    }
  }

  int maxIndex() {
    int max = widget.categories[0]["index"];
    for (Map cate in widget.categories) {
      if (max < cate["index"]) max = cate["index"];
    }
    return max;
  }

  double getCenterPos() {
    return (MediaQuery.of(context).size.width / 2) -
        (size.width / 2) -
        widget.outPadding;
  }

  Widget animatedTile(Map cate) {
    double centerPos = getCenterPos();
    double pos = screenCount == 0
        ? centerPos
        : centerPos + (size.width + gap) * (cate["index"] - focus);
    int sleep = 700 + (cate["index"] * 40).toInt() as int;
    return AnimatedPositioned(
      onEnd: () {
        if (pos < -(size.width * 2)) {
          setState(() {
            cate["index"] = maxIndex() + 1;
            cate["ani"] = false;
          });
        } else if (!cate["ani"]) {
          setState(() {
            cate["ani"] = true;
          });
        }
      },
      curve: Curves.easeInBack,
      duration: Duration(milliseconds: sleep),
      left: pos,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 10),
        opacity: cate["ani"] ? 1 : 0,
        child: CategoryTile(
          cate,
          size: size,
          detail: pos == centerPos,
        ),
      ),
    );
  }

  Widget animatedCategories() {
    return AnimatedContainer(
      height: size.height,
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: widget.categories.map((cate) => animatedTile(cate)).toList(),
      ),
    );
  }

  Widget textCategoryList() {
    widget.categories.last["padding"] = false;
    Widget category(String title, {bool padding = true}) => Container(
          color: Colors.green,
          margin: EdgeInsets.only(right: padding ? 30 : 0),
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text("$title: $padding"),
        );
    return Container(
      color: Colors.green[200],
      width: double.infinity,
      padding:  EdgeInsets.symmetric(horizontal: 100),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          color: Colors.red,
          // width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.categories
                .map((Map c) => category(c["title"], padding: c["padding"] ?? true))
                .toList(),
          ),
        ),
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
      cate.value["ani"] = true;
    }
    focus = widget.categories.length ~/ 2;
    autoScroll();
  }

  @override
  Widget build(BuildContext context) {
    initWithSize();
    return Column(
      children: [
        textCategoryList(),
        animatedCategories(),
        // Container(
        //   height: 2,
        //   margin: const EdgeInsets.symmetric(vertical: 10),
        //   decoration: BoxDecoration(
        //     color: Colors.black,
        //     borderRadius: BorderRadius.circular(15),
        //   ),
        // ),
      ],
    );
  }
}

class CategoryTile extends StatefulWidget {
  const CategoryTile(this.data,
      {super.key, this.size = const Size(300, 400), this.detail = false});
  final Size size;
  final Map data;
  final bool detail;

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  bool center = false;
  bool onDetail = false;

  Widget frontTitle() {
    return Positioned(
      right: 20,
      bottom: 25,
      child: Opacity(
        opacity: 0.6,
        child: Text(
          widget.data["title"],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
      ),
    );
  }

  Widget detailCover() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: onDetail ? 1 : 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(15),
        ),
        width: widget.size.width,
        height: widget.size.height,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.data["title"],
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                widget.data["description"],
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getDetail() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 10));
      if (widget.detail) {
        center = true;
        await Future.delayed(const Duration(milliseconds: 700));
        setState(() {
          onDetail = widget.detail;
        });
      } else {
        setState(() {
          center = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getDetail();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (var event) {
        if (!center) {
          setState(() {
            onDetail = true;
          });
        }
      },
      onExit: (var event) {
        if (!center) {
          setState(() {
            onDetail = false;
          });
        }
      },
      child: GestureDetector(
        onTap: () {
          print(widget.data["path"]);
        },
        child: Container(
          width: widget.size.width,
          height: widget.size.height,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              frontTitle(),
              detailCover(),
            ],
          ),
        ),
      ),
    );
  }
}
