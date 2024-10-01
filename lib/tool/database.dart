import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Database {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseDatabase rtDb = FirebaseDatabase.instance;

  // TOOL
  List<Map> mapToList(Map from) {
    List<Map> result = [];
    int index = 0;
    for (MapEntry e in from.entries) {
      Map data = e.value;
      data["id"] = e.key;
      data["index"] = index;
      index++;
      result.add(data);
    }
    return result;
  }

  // CRUD
  Future<List<Map>> getCategoryList() async {
    CollectionReference col = db.collection("category");
    Map data = {};
    for (var doc in (await col.get()).docs) {
      data[doc.id] = doc.data();
    }
    print("Get Data in Category Collection");
    return mapToList(data);
  }

  Future<bool> isUserTodayWithIp(String ip) async {
    CollectionReference col = db.collection("user");
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var data = await col
        .where('last_enter', isGreaterThanOrEqualTo: today)
        .where("ip", isEqualTo: ip)
        .get();
    print("Checked User IP is in DB...");
    return data.docs.isNotEmpty;
  }

  Future<void> addUser(Map user) async {
    CollectionReference col = db.collection("user");
    var data = await col.where("ip", isEqualTo: user["ip"]).get();
    if (data.docs.isNotEmpty) {
      col.doc(data.docs[0].id).update({"last_enter": user["last_enter"]});
      print("Update User Data");
    } else {
      await col.add(user);
      print("Post User Data");
    }
  }

  StreamSubscription<DatabaseEvent> listenSiteInfo(void Function(DatabaseEvent) listener) {
    Stream<DatabaseEvent> stream = rtDb.ref("site_info").onValue;
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
    print("Update User Count");
  }
}
