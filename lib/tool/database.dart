import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Data Set in Page Function
  Future<Map> mainLobbyData() async {
    Map recentPost = await getRecentPost();
    Map categoryData = await getCategory();
    return {
      "category": mapToList(categoryData),
      "recentPost": mapToList(recentPost),
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
      index++;
      result.add(data);
    }
    return result;
  }

  // CRUD
  Future<Map> getCategory() async {
    CollectionReference col = db.collection("category");
    Map data = {};
    for (var doc in (await col.get()).docs) {
      data[doc.id] = doc.data();
    }
    print("Get Data in Category Collection");
    return data;
  }

  Future<Map> getRecentPost({String? category}) async {
    CollectionReference col = db.collection("post_list");
    Query query = col
        .orderBy(
          "updated_at",
          descending: true,
        )
        .limit(10);
    if (category != null) {
      query = query.where('category_id', arrayContains: category);
    }
    Map data = {};
    for (var doc in (await query.get()).docs) {
      data[doc.id] = doc.data();
    }
    print("Get Data in Post List Collection");
    return data;
  }

  Future<List<Map>> getCategoryList() async {
    CollectionReference col = db.collection("category");
    Map data = {};
    for (var doc in (await col.get()).docs) {
      data[doc.id] = doc.data();
    }
    print("Get Data in Category Collection");
    return mapToList(data);
  }
}
