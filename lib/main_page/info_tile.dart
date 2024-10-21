import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:portfolio/base_data.dart';

class InfoTile extends StatefulWidget {
  final bool active;
  const InfoTile({super.key, this.active = false});

  @override
  State<InfoTile> createState() => _InfoTileState();
}

class _InfoTileState extends State<InfoTile> {
  StreamSubscription<DatabaseEvent>? dataListener;
  Map infoData = {
    "user_count": 0,
    "user_total": 0,
    "like_count": 0,
    "comment_count": 0,
    "comment_total": 0,
  };

  void setData(event) {
    setState(() {
      infoData = event.snapshot.value;
    });
  }

  Future<void> countUser() async {
    Uri url = Uri.parse("https://ipinfo.io/json");
    final response = await http.get(url);
    if (mounted && response.statusCode == 200) {
      var db = BaseData.of(context)!.db;
      Map user = jsonDecode(response.body);
      if (!(await db.isUserTodayWithIp(user["ip"]))) {
        user["last_enter"] = DateTime.now();
        await db.realtimeUpdateUserCount();
        await db.addUser(user);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    countUser();
  }

  @override
  Widget build(BuildContext context) {
    if (dataListener == null && widget.active) {
      dataListener = BaseData.of(context)!.db.listenSiteInfo(setData);
    } else if (dataListener != null && !widget.active) {
      dataListener!.cancel();
      dataListener = null;
    }
    Widget text(String key, String value) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              key,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontFamily: "dangdang",
                fontSize: 12,
                wordSpacing: 0.2,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontFamily: "dangdang",
                fontSize: 12,
                wordSpacing: 0.2,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      height: 100,
      width: 170,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          text(
            "접속 수 (누적): ",
            "${infoData["user_count"]} (${infoData["user_total"]})",
          ),
          text("좋아요 수: ", "${infoData["like_count"]}"),
          text(
            "댓글 수 (누적): ",
            "${infoData["comment_count"]} (${infoData["comment_total"]})",
          ),
        ],
      ),
    );
  }
}
