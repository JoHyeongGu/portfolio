import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' show Document;
import 'package:html/parser.dart' show parse;
import 'package:portfolio/tool/tool_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

const String corsUrl = "https://corsproxy.io/?";

Widget text(String txt) {
  TextStyle style = const TextStyle(
    fontSize: 18,
    fontFamily: "magicpen",
  );
  List<TextSpan> spanList = [];
  for (MapEntry word in txt.split("<b>").asMap().entries) {
    if (word.key % 2 == 0) {
      spanList.add(TextSpan(text: word.value, style: style));
    } else {
      TextStyle boldStyle = style.copyWith(fontWeight: FontWeight.bold);
      spanList.add(TextSpan(text: word.value, style: boldStyle));
    }
  }
  return Theme(
    data: ThemeData(
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: Colors.yellow,
      ),
    ),
    child: SelectableText.rich(
      TextSpan(children: spanList),
      textAlign: TextAlign.start,
    ),
  );
}

Widget code(String txt) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 50),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Theme(
      data: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Colors.green,
        ),
      ),
      child: SelectableText(
        txt.replaceAll("\\n", "\n"),
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  );
}

Widget image(String txt) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
    child: Image.network(corsUrl + txt),
  );
}

Widget t1(String txt) {
  TextStyle style = const TextStyle(
    fontSize: 35,
    fontFamily: "magicpen",
  );
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Theme(
      data: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Colors.yellow,
        ),
      ),
      child: SelectableText(txt, style: style),
    ),
  );
}

Widget t2(String txt) {
  TextStyle style = const TextStyle(
    fontSize: 25,
    fontFamily: "magicpen",
  );
  return Padding(
    padding: const EdgeInsets.only(top: 10, bottom: 5),
    child: Theme(
      data: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Colors.yellow,
        ),
      ),
      child: SelectableText(txt, style: style),
    ),
  );
}

Widget link(String txt) {
  Future<Map<String, String?>> getData() async {
    String? title;
    String? description;
    String? img;
    try {
      final response = await http.get(
        Uri.parse(corsUrl + txt),
      );
      if (response.statusCode == 200) {
        Document doc = parse(response.body);
        var titleTag = doc.querySelector("title");
        if (titleTag != null) {
          title = titleTag.text;
        }
        var descriptionTag = doc.querySelector("meta[name='description']");
        if (descriptionTag != null) {
          description = descriptionTag.attributes["content"];
          if (description != null && description.length > 100) {
            description = "${description.substring(0, 100)}...";
          }
        }
        var imgTag = doc.querySelector("meta[property*='image']");
        if (imgTag != null) {
          img = imgTag.attributes["content"]!;
        }
      }
    } catch (_) {}
    return {
      "title": title,
      "description": description,
      "img": img != null ? "https://corsproxy.io/?$img" : null,
    };
  }

  Widget nodata() {
    return Linkify(
      text: txt,
      onOpen: (link) async {
        if (!await launchUrl(Uri.parse(link.url))) {
          throw Exception('Could not launch ${link.url}');
        }
      },
      style: const TextStyle(fontWeight: FontWeight.bold),
      linkStyle: const TextStyle(color: Colors.green),
    );
  }

  Widget linkBox(BuildContext context, Map<String, String?> data) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapUp: (details) async {
          if (!await launchUrl(Uri.parse(txt))) {
            throw Exception('Could not launch $txt');
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 15),
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              data["img"] != null
                  ? Padding(
                      padding: const EdgeInsets.all(15),
                      child: SizedBox(
                        width: 100,
                        height: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            data["img"]!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(15),
                      width: 100,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["title"]!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      data["description"]!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  return FutureBuilder(
    future: getData(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return loadingWidget(
          color: Colors.brown,
          edgeInsets: const EdgeInsets.symmetric(vertical: 30),
        );
      } else if (snapshot.hasData) {
        Map<String, String?> data = snapshot.data as Map<String, String?>;
        return data["title"] == null ? nodata() : linkBox(context, data);
      } else {
        return Container();
      }
    },
  );
}

class SummeryTable extends StatefulWidget {
  final String content;
  const SummeryTable(this.content, {super.key});

  @override
  State<SummeryTable> createState() => _SummeryTableState();
}

class _SummeryTableState extends State<SummeryTable> {
  late Iterable<RegExpMatch> tags;

  Widget tile(RegExpMatch e) {
    String part = widget.content.substring(e.start, e.end);
    bool big = part.contains("<t1>");
    return Padding(
      padding: big ? EdgeInsets.zero : const EdgeInsets.only(left: 20),
      child: Text(
        part.split(">")[1].split("<")[0],
        style: TextStyle(
          fontSize: big ? 15 : 13,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    tags = RegExp(r"<t(.*?)>(.*?)</t(.*?)>").allMatches(widget.content);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.brown.withOpacity(0.6),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.only(top: 50, bottom: 80, right: 20, left: 20),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "< 목차 >",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: "magicpen",
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...tags.map((RegExpMatch e) => tile(e)),
        ],
      ),
    );
  }
}
