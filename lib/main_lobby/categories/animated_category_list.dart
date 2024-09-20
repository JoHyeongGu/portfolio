import 'package:flutter/material.dart';
import 'package:portfolio/main_lobby/categories/summery_cate_list.dart';

class AnimatedCategoryList extends StatefulWidget {
  final Map<int, Map> categories;
  final double outPadding;

  const AnimatedCategoryList(this.categories, {super.key, this.outPadding = 0});

  @override
  State<AnimatedCategoryList> createState() => _AnimatedCategoryListState();
}

class _AnimatedCategoryListState extends State<AnimatedCategoryList> {
  List<Map> categories = [];
  Size size = const Size(300, 400);
  bool stopAutoScroll = false;
  int screenCount = 0;
  double gap = 40;
  late int focus;

  void initCategories() {
    for (MapEntry cate in widget.categories.entries) {
      Map data = {};
      for (MapEntry c in cate.value.entries) {
        data[c.key] = c.value;
      }
      data["index"] = cate.key;
      categories.add(data);
    }
    if (categories.length % 2 == 0) {
      categories.add({});
    }
  }

  void restartAutoScroll() {
    resetIndex();
    setState(() {
      stopAutoScroll = false;
    });
    autoScroll();
  }

  void setFixedFocus(int _focus) async {
    setState(() {
      focus = _focus;
      stopAutoScroll = true;
    });
  }

  void initWithSize() {
    screenCount = (MediaQuery.of(context).size.width / size.width).toInt();
    if (screenCount % 2 == 0) screenCount--;
  }

  void resetIndex() {
    for (Map cate in categories) {
      cate["index"] -= focus;
    }
    focus = 0;
    setState(() {});
  }

  void autoScroll() async {
    while (mounted) {
      if (!stopAutoScroll) focus++;
      if (!stopAutoScroll && focus >= categories.length) resetIndex();
      if (!stopAutoScroll) setState(() {});
      if (!stopAutoScroll) await Future.delayed(const Duration(seconds: 3));
      if (stopAutoScroll) break;
    }
  }

  int maxIndex() {
    int max = categories[0]["index"];
    for (Map cate in categories) {
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
        children: categories.map((cate) => animatedTile(cate)).toList(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initCategories();
    for (MapEntry cate in categories.asMap().entries) {
      cate.value["index"] = cate.key;
      cate.value["ani"] = true;
    }
    focus = categories.length ~/ 2;
    autoScroll();
  }

  @override
  Widget build(BuildContext context) {
    initWithSize();
    return Column(
      children: [
        SummeryCateList(
          categories,
          enter: setFixedFocus,
          exit: restartAutoScroll,
        ),
        animatedCategories(),
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

  void setDetail(bool turn) {
    if (!center && onDetail != turn) {
      setState(() {
        onDetail = turn;
      });
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
      cursor: SystemMouseCursors.click,
      onEnter: (event) => setDetail(true),
      onExit: (event) => setDetail(false),
      child: GestureDetector(
        onTapUp: (details) {
          setDetail(false);
          print(widget.data["path"]);
        },
        onTapDown: (details) => setDetail(true),
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
