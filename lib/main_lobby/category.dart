import 'package:flutter/material.dart';

class Category extends StatefulWidget {
  final List<Map> categories;
  final double outPadding;

  const Category(this.categories, {super.key, this.outPadding = 0});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  Size size = const Size(300, 400);
  bool stopAutoScroll = false;
  int screenCount = 0;
  double gap = 40;
  late int focus;

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
    for (Map cate in widget.categories) {
      cate["index"] -= focus;
    }
    focus = 0;
    setState(() {});
  }

  void autoScroll() async {
    while (mounted) {
      if (!stopAutoScroll) focus++;
      if (!stopAutoScroll && focus >= widget.categories.length) resetIndex();
      if (!stopAutoScroll) setState(() {});
      if (!stopAutoScroll) await Future.delayed(const Duration(seconds: 3));
      if (stopAutoScroll) break;
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
        CateSummeryLine(
          widget.categories,
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

class CateSummeryLine extends StatefulWidget {
  final List<Map> categories;
  final void Function(int) enter;
  final void Function() exit;

  const CateSummeryLine(
    this.categories, {
    super.key,
    required this.enter,
    required this.exit,
  });

  @override
  State<CateSummeryLine> createState() => _CateSummeryLineState();
}

class _CateSummeryLineState extends State<CateSummeryLine> {
  String focusTitle = "";

  void click(Map cate) {
    if (focusTitle != cate["title"]) {
      setState(() {
        focusTitle = cate["title"];
      });
      widget.enter(cate["index"]);
    } else {
      setState(() {
        focusTitle = "";
      });
      widget.exit();
    }
  }

  Widget sortLine = Align(
    alignment: Alignment.center,
    child: Container(
      color: Colors.brown,
      height: 2,
      width: double.infinity,
    ),
  );

  @override
  void initState() {
    super.initState();
    widget.categories.last["padding"] = false;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Stack(
        children: [
          sortLine,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widget.categories
                  .map(
                    (Map cate) => SummaryTile(
                      cate,
                      click: click,
                      focusTitle: focusTitle,
                      padding: cate["padding"] ?? true,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryTile extends StatefulWidget {
  final Map cate;
  final bool padding;
  final String focusTitle;
  final void Function(Map) click;

  const SummaryTile(
    this.cate, {
    super.key,
    required this.padding,
    required this.click,
    required this.focusTitle,
  });

  @override
  State<SummaryTile> createState() => _SummaryTileState();
}

class _SummaryTileState extends State<SummaryTile> {
  bool focus = false;

  Widget pin() => Container(
        height: 5,
        width: 5,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: focus ? Colors.grey[400] : Colors.grey,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 1,
              spreadRadius: 1,
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    focus = widget.focusTitle == widget.cate["title"];
    return GestureDetector(
      onTap: () {
        widget.click(widget.cate);
      },
      child: SizedBox(
        height: 30,
        child: Container(
          margin: EdgeInsets.only(right: widget.padding ? 30 : 0),
          decoration: BoxDecoration(
            color:
                focus ? Color.fromRGBO(178, 155, 129, 1.0) : Colors.grey[400],
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 0.7,
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            children: [
              pin(),
              Text(
                widget.cate["title"],
                style: TextStyle(
                  fontWeight: focus ? FontWeight.bold : FontWeight.normal,
                  fontSize: focus ? 16 : 15,
                ),
              ),
              pin(),
            ],
          ),
        ),
      ),
    );
  }
}
