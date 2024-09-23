import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  late FirebaseFirestore db;

  Database() {
    db = FirebaseFirestore.instance;
  }

  // Data Set in Page Function
  Future<Map> mainLobbyData() async {
    Map categoryData = await getCategory();
    List<Map> categoryList = mapToList(categoryData);

    return {
      "category": categoryList,
    };
  }

  // TOOL
  List<Map> mapToList(Map from) {
    List<Map> result = [];
    int index = 0;
    for (MapEntry e in from.entries) {
      Map data = e.value;
      data["id"] = e.key;
      data["index"] = index;
      result.add(data);
    }
    return result;
  }

  Future<Map> getCategory() async {
    Map data = {};
    CollectionReference col = db.collection("category");
    for (var doc in (await col.get()).docs) {
      data[doc.id] = doc.data();
    }
    print("Get Data in Category Collection");
    return data;
  }
}
