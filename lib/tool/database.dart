import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart' as realtime;

class Database {
  FirebaseFirestore db = FirebaseFirestore.instance;
  realtime.FirebaseDatabase rtDb = realtime.FirebaseDatabase.instance;

  Future<List<Map>> getCategoryList() async {
    CollectionReference col = db.collection("category");
    List<Map> result = [];
    int index = 0;
    for (var doc in (await col.get()).docs) {
      result.add({
        "id": doc.id,
        "index": index,
        ...(doc.data() as Map),
      });
      index++;
    }
    return result;
  }

  Future<List<Map>> getRecentPostList() async {
    CollectionReference col = db.collection("post_list");
    Query query = col.orderBy("updated_at", descending: true).limit(5);
    List<Map> datas = (await query.get())
        .docs
        .map((doc) => {"id": doc.id, ...(doc.data() as Map)})
        .toList();
    return datas;
  }

  Future<Map<String, dynamic>?> getPostDataById(String id) async {
    return (await db.collection("post_list").doc(id).get()).data();
  }

  Future<bool> isUserTodayWithIp(String ip) async {
    CollectionReference col = db.collection("user");
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var data = await col
        .where('last_enter', isGreaterThanOrEqualTo: today)
        .where("ip", isEqualTo: ip)
        .get();
    return data.docs.isNotEmpty;
  }

  Future<void> addUser(Map user) async {
    CollectionReference col = db.collection("user");
    var data = await col.where("ip", isEqualTo: user["ip"]).get();
    if (data.docs.isNotEmpty) {
      col.doc(data.docs[0].id).update({"last_enter": user["last_enter"]});
    } else {
      await col.add(user);
    }
  }

  StreamSubscription<realtime.DatabaseEvent> listenSiteInfo(
      void Function(realtime.DatabaseEvent) listener) {
    Stream<realtime.DatabaseEvent> stream = rtDb.ref("site_info").onValue;
    return stream.listen(listener);
  }

  Future<void> realtimeUpdateUserCount() async {
    String today = DateTime.now().toString().split(" ")[0];
    Map info = (await rtDb.ref("site_info").get()).value as Map;
    if (today == (await rtDb.ref("last_date").get()).value) {
      await rtDb.ref("site_info/user_count").set(info["user_count"] + 1);
    } else {
      await rtDb.ref("site_info/user_count").set(1);
      await rtDb.ref("last_date").set(today);
    }
    await rtDb.ref("site_info/user_total").set(info["user_total"] + 1);
  }
}
