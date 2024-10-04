import 'package:flutter/material.dart';
import 'package:portfolio/base_data.dart';
import 'package:portfolio/tool/color_list.dart';

class RecentPostList extends StatefulWidget {
  const RecentPostList({super.key});

  @override
  State<RecentPostList> createState() => _RecentPostListState();
}

class _RecentPostListState extends State<RecentPostList> {
  List<Map>? datas;

  void getDatas() async {
    if (datas == null) {
      datas = await BaseData.of(context)!.db.getRecentPostList();
      print(datas);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    getDatas();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 45),
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
        color: COLOR_IVORY,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
