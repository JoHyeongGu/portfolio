import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/router.dart';
import 'package:portfolio/tool/color_list.dart';
import 'package:portfolio/tool/tool_widgets.dart';

class PostList extends StatefulWidget {
  final List<Map> postList;
  final Map<String, dynamic> params;
  const PostList(this.postList, {super.key, required this.params});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  String searchKeyword = "";
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.params.keys.contains("search")) {
      setState(() {
        searchKeyword = widget.params["search"][0];
        controller.text = widget.params["search"][0];
      });
    }
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.white,
              size: 20,
            ),
          ),
          Flexible(
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(7),
              ),
              padding: const EdgeInsets.only(top: 5),
              child: TextFormField(
                controller: controller,
                onChanged: (String word) {
                  setState(() {
                    searchKeyword = word;
                  });
                },
                cursorHeight: 20,
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: "noonnuGodic",
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget postTile(Map data) {
    List<String> contentToken = data["content"].split("<n>");
    String parsingContent(String before) {
      if (!before.contains("<") && !before.contains(">")) return before;
      String after = "";
      for (String token in before.split("<")) {
        if (token == "") continue;
        after += token.split(">")[1];
      }
      return after;
    }

    String content =
        "${parsingContent(contentToken[0])}\n${parsingContent(contentToken[1])}";
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapUp: (details) {
          WebRouter.navigateTo(context, "/post?id=${data["id"]}");
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: fixColorIvory.withOpacity(0.9),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    data["thumbnail"],
                    fit: BoxFit.fitHeight,
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          data["title"],
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: "noonnuGodic",
                          ),
                        ),
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.5),
                          child: Text(
                            (data["created_at"] as Timestamp)
                                .toDate()
                                .toIso8601String()
                                .split("T")[0],
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: "noonnuGodic",
                                color: Colors.black.withOpacity(0.8)),
                          ),
                        )
                      ],
                    ),
                    Text(
                      content,
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: "noonnuGodic",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.decelerate,
      duration: const Duration(milliseconds: 500),
      height: double.infinity,
      width: widget.postList.isNotEmpty
          ? MediaQuery.of(context).size.width * (3 / 4)
          : 0,
      color: Colors.black.withOpacity(0.3),
      padding:
          const EdgeInsets.only(top: 100, bottom: 30, left: 100, right: 100),
      child: Column(
        children: [
          searchBar(),
          Flexible(
            child: smoothScroll(
              child: Column(
                children: widget.postList
                    .where((post) =>
                        searchKeyword == "" ||
                        post["title"]
                            .toUpperCase()
                            .contains(searchKeyword.toUpperCase()) ||
                        post["content"]
                            .toUpperCase()
                            .contains(searchKeyword.toUpperCase()))
                    .map((post) => postTile(post))
                    .toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
