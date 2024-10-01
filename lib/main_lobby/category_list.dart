import 'package:flutter/material.dart';
import 'package:portfolio/base_data.dart';
import 'package:portfolio/router.dart';
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
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      if (autoCount > 1 || !widget.open) {
        autoCount--;
        break;
      }
      focus++;
      if (focus >= data.length) focus = 0;
      await Future.delayed(const Duration(seconds: 3));
    }
  }

  void fixCategoryTile(int index) {
    autoCount++;
    focus = index;
    _controller.animateTo(
      (size.width + 15) * (focus + 1),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  void startAutoScroll() async {
    autoCount--;
    await Future.delayed(const Duration(seconds: 1));
    if (autoCount == 0 && widget.open && data.isNotEmpty) {
      autoScroll();
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

  @override
  Widget build(BuildContext context) {
    getData();
    return Column(
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
        CateTextList(
          data,
          size: size,
          enter: fixCategoryTile,
          exit: startAutoScroll,
        ),
      ],
    );
  }
}

class CateTextList extends StatefulWidget {
  final Size size;
  final List<Map> datas;
  final void Function(int) enter;
  final void Function() exit;
  const CateTextList(
    this.datas, {
    super.key,
    required this.size,
    required this.enter,
    required this.exit,
  });

  @override
  State<CateTextList> createState() => _CateTextListState();
}

class _CateTextListState extends State<CateTextList> {
  bool more = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: widget.size.width,
          height: more ? 26 * widget.datas.length + 10 as double : 135,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.datas
                  .map(
                    (data) => CateText(
                      data,
                      enter: widget.enter,
                      exit: widget.exit,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Center(
            child: IconButton(
              onPressed: () => setState(() {
                more = !more;
              }),
              icon: Icon(
                more ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class CateText extends StatefulWidget {
  final Map data;
  final void Function(int) enter;
  final void Function() exit;
  const CateText(
    this.data, {
    super.key,
    required this.enter,
    required this.exit,
  });

  @override
  State<CateText> createState() => _CateTextState();
}

class _CateTextState extends State<CateText> {
  bool focus = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (details) => setState(() {
          focus = true;
          widget.enter(widget.data["index"]);
        }),
        onExit: (details) => setState(() {
          focus = false;
          widget.exit();
        }),
        child: GestureDetector(
          onTapDown: (details) => setState(() {
            focus = true;
            widget.enter(widget.data["index"]);
          }),
          onTapUp: (event) {
            WebRouter.navigateTo(context, "/test?cate=${widget.data["path"]}&type=test");
          },
          onTapCancel: () => setState(() {
            focus = false;
            widget.exit();
          }),
          child: Text(
            widget.data["title"],
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: "dangdang",
              letterSpacing: 1,
              fontWeight: focus ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
