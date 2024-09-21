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
  String focusTitle = "";
  double totalHeight = 50;

  final ScrollController _scrollController = ScrollController();

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

  Widget title() {
    return Container(
      height: totalHeight,
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      child: const tag(
        content: Text(
          "카테고리",
          style: TextStyle(
              fontFamily: "magicpen",
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white),
        ),
      ),
    );
  }

  Widget sortLine() {
    return Padding(
      padding: EdgeInsets.only(top: totalHeight / 2),
      child: Container(
        color: Colors.brown,
        height: 2,
        width: double.infinity,
      ),
    );
  }

  Widget mainLine() {
    return SizedBox(
      height: totalHeight,
      width: double.infinity,
      child: Stack(
        children: [
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
          if (MediaQuery.of(context).size.width > 600)
            ScrollMouseController(_scrollController),
        ],
      ),
    );
  }

  Widget searchTag() {
    return Container(
      height: totalHeight,
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      child: const tag(
        content: SearchContent(),
        contentPadding: false,
      ),
    );
  }

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
    return Stack(
      children: [
        sortLine(),
        Row(
          children: [
            title(),
            Flexible(
              child: mainLine(),
            ),
            searchTag(),
          ],
        ),
      ],
    );
  }
}

class tag extends StatelessWidget {
  final bool color;
  final Widget content;
  final double height;
  final bool contentPadding;

  const tag({
    super.key,
    required this.content,
    this.color = true,
    this.height = 50,
    this.contentPadding = true,
  });

  Widget pin({required bool left}) {
    EdgeInsetsGeometry padding = contentPadding
        ? const EdgeInsets.symmetric(horizontal: 12)
        : left
            ? const EdgeInsets.only(left: 12)
            : const EdgeInsets.only(right: 12);
    return Container(
      height: 5,
      width: 5,
      margin: padding,
      decoration: BoxDecoration(
        color: color ? Colors.grey[400] : Colors.grey,
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color:
            color ? const Color.fromRGBO(178, 155, 129, 1.0) : Colors.grey[400],
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          pin(left: true),
          content,
          pin(left: false),
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

  @override
  Widget build(BuildContext context) {
    focus = widget.focusTitle == widget.cate["title"];
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          widget.click(widget.cate);
        },
        child: Padding(
          padding: EdgeInsets.only(
              right: widget.padding ? 30 : 0, top: 10, bottom: 10),
          child: tag(
            content: Text(
              widget.cate["title"],
              style: TextStyle(
                fontFamily: "magicpen",
                fontWeight: focus ? FontWeight.bold : FontWeight.normal,
                fontSize: focus ? 17 : 16,
              ),
            ),
            color: focus,
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
      await Future.delayed(const Duration(milliseconds: 10));
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
        duration: const Duration(milliseconds: 300),
        opacity: visible ? 1 : 0,
        child: Container(
          margin: left
              ? const EdgeInsets.only(right: 30, left: 5)
              : const EdgeInsets.only(left: 10, right: 5),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.7),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Icon(
              left ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
              color: Colors.white,
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

class SearchContent extends StatefulWidget {
  const SearchContent({super.key});

  @override
  State<SearchContent> createState() => _SearchContentState();
}

class _SearchContentState extends State<SearchContent> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.transparent,
      child: Row(
        children: [
          IconButton(
            onPressed: () => setState(() {
              open = !open;
            }),
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.only(right: open ? 12 : 0),
            color: Colors.white,
            height: 20,
            width: open ? MediaQuery.of(context).size.width > 1000 ? 180 : 100 : 0,
          ),
        ],
      ),
    );
  }
}
