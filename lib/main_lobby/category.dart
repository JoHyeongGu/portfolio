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

  void resetIndex() {
    for (Map cate in widget.categories) {
      cate["index"] -= focus;
    }
    focus = 0;
    setState(() {});
  }

  void autoScroll() async {
    while (true) {
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
        (tileWidth / 2) -
        (widget.outPadding + innerPadding);
  }

  Widget animatedTile(Map cate) {
    double centerPos = getCenterPos();
    double pos = screenCount == 0
        ? centerPos
        : centerPos + (tileWidth + gap) * (cate["index"] - focus);
    int sleep = 700 + (cate["index"] * 40).toInt() as int;
    return AnimatedPositioned(
      onEnd: () {
        if (pos < -(tileWidth * 2)) {
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
          width: tileWidth,
          height: tileHeight,
          detail: pos == centerPos,
        ),
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
      cate.value["ani"] = true;
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
      {super.key, this.width = 300, this.height = 400, this.detail = false});
  final Map data;
  final bool detail;
  final double width;
  final double height;

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  bool center = false;
  bool onDetail = false;
  late String title;
  late String description;

  void getDetail() async {
    while (true) {
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
    title =
        widget.data.keys.toList().contains("title") ? widget.data["title"] : "";
    description = widget.data.keys.toList().contains("description")
        ? widget.data["description"]
        : "";
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
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      description,
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
          ),
        ),
      ),
    );
  }
}
