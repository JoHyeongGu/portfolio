import 'package:flutter/material.dart';
import 'content_widget_dict.dart';

class PostContents extends StatelessWidget {
  final String content;
  final List<Widget> widgetList = [];

  PostContents(this.content, {super.key}) {
    parsingContent(content);
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 40,
      ),
      child: Column(
        children: widgetList,
      ),
    );
  }
}
