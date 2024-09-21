import 'package:flutter/material.dart';

class SummeryCateList extends StatefulWidget {
  final List<Map> categories;
  final void Function(int) enter;
  final void Function() exit;

  const SummeryCateList(
    this.categories, {
    super.key,
    required this.enter,
    required this.exit,
  });

  @override
  State<SummeryCateList> createState() => _SummeryCateListState();
}

class _SummeryCateListState extends State<SummeryCateList> {
  final ScrollController _scrollController = ScrollController();
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
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.categories.last["padding"] = false;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Stack(
        children: [
          sortLine,
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            controller: _scrollController,
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
          ScrollMouseController(_scrollController),
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
        height: 50,
        child: Container(
          margin: EdgeInsets.only(
              right: widget.padding ? 30 : 0, top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: focus
                ? const Color.fromRGBO(178, 155, 129, 1.0)
                : Colors.grey[400],
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 0.7,
                blurRadius: 5,
              ),
            ],
          ),
          child: Row(
            children: [
              pin(),
              Text(
                widget.cate["title"],
                style: TextStyle(
                  // color: focus ? Colors.white : Colors.black,
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

class ScrollMouseController extends StatefulWidget {
  const ScrollMouseController(this._scrollController, {super.key});
  final ScrollController _scrollController;

  @override
  State<ScrollMouseController> createState() => _ScrollMouseControllerState();
}

class _ScrollMouseControllerState extends State<ScrollMouseController> {
  bool visible = false;
  bool move = false;

  void moveScroll({required bool left}) async {
    Duration time = const Duration(milliseconds: 300);
    Curve curve = Curves.linear;
    double speed = 200;
    while (true) {
      if (!move) break;
      if (left) {
        widget._scrollController.animateTo(
            widget._scrollController.offset - speed,
            duration: time,
            curve: curve);
      } else {
        widget._scrollController.animateTo(
            widget._scrollController.offset + speed,
            duration: time,
            curve: curve);
      }
      await Future.delayed(Duration(milliseconds: 10));
      if (!move) break;
    }
  }

  Widget controlPoint({required bool left}) {
    return MouseRegion(
      onEnter: (event) {
        move = true;
        moveScroll(left: left);
        setState(() {
          visible = true;
        });
      },
      onExit: (event) => setState(() {
        move = false;
        visible = false;
      }),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: visible ? 1 : 0,
        child: Container(
          margin: left
              ? EdgeInsets.only(right: 30, left: 5)
              : EdgeInsets.only(left: 10, right: 5),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.7),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Icon(
              left ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
              color: Colors.white,
              // shadows: [
              //   Shadow(
              //     color: Colors.black,
              //     blurRadius: 3,
              //   ),
              // ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            controlPoint(left: true),
            controlPoint(left: false),
          ],
        ),
      ),
    );
  }
}
