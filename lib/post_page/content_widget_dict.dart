import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' show Document;
import 'package:html/parser.dart' show parse;

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
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(children: spanList),
  );
}

Widget code(String txt) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 45),
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
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Image.network(txt),
  );
}

Widget t1(String txt) {
  TextStyle style = const TextStyle(
    fontSize: 35,
    fontFamily: "magicpen",
  );
  return SizedBox(
    height: 58,
    child: Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 5),
      child: Text(txt, style: style),
    ),
  );
}

Widget t2(String txt) {
  TextStyle style = const TextStyle(
    fontSize: 22,
    fontFamily: "magicpen",
  );
  return Padding(
    padding: const EdgeInsets.only(top: 10, bottom: 5),
    child: Text(txt, style: style),
  );
}

Widget link(String txt) {
  Future<Map<String, String?>> getData() async {
    String? title;
    String? description;
    String? img;
    try {
      final response = await http.get(Uri.parse(txt));
      print("Complete $txt Get");
      if (response.statusCode == 200) {
        Document doc = parse(response.body);
        var titleTag = doc.querySelector("title");
        if (titleTag != null) {
          title = titleTag.text;
        }
        var descriptionTag = doc.querySelector("meta[name='description']");
        if (descriptionTag != null) {
          description = descriptionTag.attributes["content"];
        }
        var imgTag = doc.querySelector("meta[property*='image']");
        if (imgTag != null) {
          img = imgTag.attributes["content"];
        }
      }
    } catch (e) {
      print(e);
    }
    return {
      "url": txt,
      "title": title,
      "description": description,
      "img": img,
    };
  }

  return FutureBuilder(
    future: getData(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasData) {
        Map<String, String?> data = snapshot.data as Map<String, String?>;
        print(data);
        return Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          width: MediaQuery.of(context).size.width / 2,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              if (data["img"] != null)
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      data["img"]!,
                    ),
                  ),
                ),
              if (data["title"] != null)
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data["title"]!),
                      Text(data["description"]!.substring(0, 100)),
                    ],
                  ),
                )
            ],
          ),
        );
      } else {
        return Container();
      }
    },
  );
}
