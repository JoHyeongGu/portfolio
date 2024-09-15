import 'package:flutter/material.dart';

class Category extends StatefulWidget {
  const Category(this.categories, {super.key, required this.width});
  final List<Map> categories;
  final double width;

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  late ScrollController _scrollController;
  late double startOffset;
  late double endOffset;
  late double stepOffset;
  late double prevStartOffset;
  double tileWidth = 300;
  double rightPadding = 40;
  int focus = 1;

  double getCloseDes() {
    double getDistance(double des) {
      double distance = des - _scrollController.offset;
      if (distance < 0) distance = -distance;
      return distance;
    }

    List<double> desList = [
      startOffset + ((focus - 1) * stepOffset),
      startOffset + (focus * stepOffset),
      startOffset + ((focus + 1) * stepOffset),
    ];
    double closeDis = getDistance(desList[0]);
    double closeDes = desList[0];
    int selectedIndex = 0;
    for (int i = 0; i < desList.length; i++) {
      double dis = getDistance(desList[i]);
      if (dis <= closeDis) {
        closeDis = dis;
        closeDes = desList[i];
        selectedIndex = i;
      }
    }
    focus = focus + selectedIndex + 1;
    if (focus >= widget.categories.length) focus = 0;
    return closeDes;
  }

  void autoScroll() async {
    await Future.delayed(const Duration(seconds: 1));
    while (true) {
      if (focus >= widget.categories.length) focus = 0;
      focus++;
      setOffset();
      if (prevStartOffset != startOffset) {
        _scrollController.animateTo(
          getCloseDes(),
          duration: const Duration(milliseconds: 800),
          curve: Curves.linear,
        );
        prevStartOffset = startOffset;
        await Future.delayed(const Duration(seconds: 1));
      } else if (_scrollController.offset >= endOffset) {
        _scrollController.jumpTo(startOffset);
        await Future.delayed(const Duration(milliseconds: 100));
      }
      _scrollController.animateTo(
        _scrollController.offset + tileWidth + rightPadding,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  void setOffset() {
    stepOffset = tileWidth + rightPadding;
    late double tileCount;
    try {
      tileCount = MediaQuery.of(context).size.width / tileWidth;
    } catch (e) {
      tileCount = widget.width / tileWidth;
    }
    double backTo = tileWidth * ((tileCount - 1) / 2);
    startOffset = (stepOffset * widget.categories.length) - backTo;
    endOffset = startOffset + (stepOffset * (widget.categories.length));
    // try {
    //   _scrollController.animateTo(
    //     startOffset,
    //     duration: const Duration(milliseconds: 300),
    //     curve: Curves.easeInOut,
    //   );
    // } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    setOffset();
    prevStartOffset = startOffset;
    _scrollController = ScrollController(initialScrollOffset: startOffset);
    autoScroll();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            setOffset();
          },
          icon: Icon(Icons.refresh),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...widget.categories.map(
                  (cate) => CategoryTile(cate,
                      width: tileWidth, rightPadding: rightPadding),
                ),
                ...widget.categories.map(
                  (cate) => CategoryTile(cate,
                      width: tileWidth, rightPadding: rightPadding),
                ),
                ...widget.categories.map(
                  (cate) => CategoryTile(cate,
                      width: tileWidth, rightPadding: rightPadding),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CategoryTile extends StatefulWidget {
  const CategoryTile(this.data,
      {super.key, required this.width, required this.rightPadding});
  final Map data;
  final double width;
  final double rightPadding;

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
          margin: EdgeInsets.only(right: widget.rightPadding),
          width: widget.width,
          height: MediaQuery.of(context).size.height / 3,
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
                  Text(widget.data["title"]),
                  Text(widget.data["description"]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
