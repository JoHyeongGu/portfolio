import 'package:flutter/material.dart';
import 'package:portfolio/main_page/logo.dart';
import 'package:portfolio/tool/color_list.dart';
import 'hamberger_menu.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget background() {
    return Container(
      color: COLOR_GREEN,
      width: double.infinity,
      height: double.infinity,
      child: Opacity(
        opacity: 0.4,
        child: Image.asset(
          "assets/drop_idea.gif",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        background(),
        const BackgroundContent(),
        const HambergerMenu(),
      ],
    );
  }
}

class BackgroundContent extends StatelessWidget {
  const BackgroundContent({super.key});

  Widget searchBar() {
    return Container(
      height: 25,
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          IconButton(
            iconSize: 17,
            padding: EdgeInsets.zero,
            onPressed: () {
              print("search");
            },
            icon: const Icon(Icons.search),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 2,
                bottom: 2,
                right: 10,
              ),
              child: MouseRegion(
                cursor: SystemMouseCursors.text,
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.grey,
                        width: 0.7,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const MainLogo(),
          const SizedBox(height: 15),
          searchBar(),
        ],
      ),
    );
  }
}
