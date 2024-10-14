import 'package:flutter/material.dart';
import 'content_widget_dict.dart';

class PostContents extends StatelessWidget {
  final Map data;
  final List<Widget> widgetList = [];

  PostContents(this.data, {super.key}) {
    parsingContent(data["content"]);
  }

  void parsingContent(String before) {
    String parsed = before.replaceAll("<n>", "\n");
    int index = 0;
    var tags = RegExp(r"<(.*?)>(.*?)</(.*?)>").allMatches(parsed);
    for (RegExpMatch tag in tags) {
      if (index != tag.start) {
        Widget widget = text(parsed.substring(index, tag.start - 1));
        widgetList.add(widget);
      }
      index = tag.end + 1;
      String part = parsed.substring(tag.start, tag.end);
      Widget widget = findWidgetType(
        type: part.split(">")[0].substring(1),
        txt: part.split(">")[1].split("</")[0],
      );
      widgetList.add(widget);
    }
    if (index != parsed.length) {
      Widget widget = text(parsed.substring(index));
      widgetList.add(widget);
    }
  }

  Widget findWidgetType({required String type, required String txt}) {
    switch (type) {
      case "img":
        return image(txt);
      case "code":
        return code(txt);
      case "t1":
        return t1(txt);
      case "t2":
        return t2(txt);
      case "link":
        return link(txt);
      default:
        return text("<$type>$txt</$type>");
    }
  }

  String getDate() {
    String parsing(DateTime date) {
      return date.toIso8601String().replaceAll("T", " ").split(".")[0];
    }

    String createdAt = parsing(data["created_at"].toDate());
    if (data.keys.contains("updated_at")) {
      return "작성일: $createdAt  (수정일: ${parsing(data["updated_at"].toDate())})";
    }
    return "작성일: $createdAt";
  }

  Widget widgetDate() {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      width: double.infinity,
      child: Text(
        getDate(),
        style: const TextStyle(
          color: Colors.brown,
        ),
      ),
    );
  }

  Widget tableSummery() {
    if (!data["content"].contains("<t")) {
      return const SizedBox(height: 20);
    }
    return SummeryTable(data["content"]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
      child: Column(
        children: [
          widgetDate(),
          tableSummery(),
          ...widgetList,
        ],
      ),
    );
  }
}
