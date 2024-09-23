import 'package:flutter/material.dart';
import 'package:portfolio/tool/color_list.dart';
import 'package:portfolio/main_lobby/profile.dart';
import 'package:portfolio/main_lobby/title_logo.dart';
import 'package:portfolio/main_lobby/post_list/recent_post_list.dart';
import 'package:portfolio/main_lobby/categories/animated_category_list.dart';
import 'package:portfolio/tool/loading.dart';

class MainFrame extends StatefulWidget {
  final Map metadata;

  const MainFrame(this.metadata, {super.key});

  @override
  State<MainFrame> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  Size contentPadding = const Size(60, 45);

  Widget categories(List<Map> categoryList) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: AnimatedCategoryList(
        categoryList,
        outPadding: contentPadding.width,
      ),
    );
  }

  Widget contents(Map data) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: contentPadding.width,
            vertical: contentPadding.height,
          ),
          child: Column(
            children: [
              categories(data["category"]),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Profile(),
                  Flexible(child: RecentPostList()),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: BACKGROUND_COLOR,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TitleLogo(),
            FutureBuilder(
                future: widget.metadata["database"].mainLobbyData(),
                builder: (context, AsyncSnapshot<Map> snapshot) {
                  if (snapshot.hasData == false) {
                    return Loading();
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    );
                  } else {
                    return contents(snapshot.data!);
                  }
                }),
            Container(
              color: PAGE_END_COLOR,
              height: 100,
              child: const Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Text(
                    "DEV_BY_JOHYEONGGU",
                    style: TextStyle(
                      wordSpacing: 0.2,
                      color: Colors.white,
                      fontFamily: "pixel",
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
