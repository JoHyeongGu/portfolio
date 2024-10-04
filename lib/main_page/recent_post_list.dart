import 'package:flutter/material.dart';
import 'package:portfolio/base_data.dart';
import 'package:portfolio/tool/color_list.dart';

class RecentPostList extends StatefulWidget {
  final bool active;

  const RecentPostList({super.key, this.active = false});

  @override
  State<RecentPostList> createState() => _RecentPostListState();
}

class _RecentPostListState extends State<RecentPostList> {
  List<Map>? datas;

  void getDatas() async {
    if (widget.active && datas == null) {
      datas = await BaseData.of(context)!.db.getRecentPostList();
      for (int i = 0; i < 4; i++) {
        Map data = {};
        for (MapEntry e in datas![0].entries) {
          data[e.key] = e.value;
        }
        if (i % 2 != 0) {
          data["title"] += data["title"];
        }
        datas!.add(data);
      }
      setState(() {});
    }
  }

  Widget post(Map data) {
    String parsedTitle(String title) {
      int max = 25;
      return title.length > max ? "${title.substring(0, max - 2)}..." : title;
    }

    return Container(
      // margin: EdgeInsets.symmetric(vertical: 3),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        // borderRadius: BorderRadius.circular(15),
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.black, width: 0.3),
        ),
      ),
      height: 80,
      child: Row(
        children: [
          Flexible(
            child: Image.network(data["thumbnail"]),
          ),
          const SizedBox(width: 10),
          Flexible(
            flex: 2,
            child: Text(parsedTitle(data["title"])),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getDatas();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 45),
      width: double.infinity,
      decoration: BoxDecoration(
        color: COLOR_IVORY,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          if (datas != null) ...datas!.map((data) => post(data)),
        ],
      ),
    );
  }
}
