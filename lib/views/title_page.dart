import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mailto/mailto.dart';
import 'package:portfolio/tool/tool.dart';
import 'package:portfolio/widgets/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TitlePage extends StatefulWidget {
  final PageController controller;
  const TitlePage(this.controller, {super.key});

  @override
  State<TitlePage> createState() => _TitlePageState();
}

class _TitlePageState extends State<TitlePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(child: cover()),
        under(),
      ],
    );
  }

  Widget cover() {
    double size = 30 + ((MediaQuery.of(context).size.width) / 70);
    if (size < 30) size = 30;
    return PageCard(
      background: MyColor.primary,
      shadow: 0.5,
      child: Center(
        child: BasicText(
          "JO'NDEA",
          size: size,
          weight: FontWeight.bold,
          color: MyColor.white,
        ),
      ),
    );
  }

  Widget under() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Stack(
        children: [
          Column(
            spacing: 3,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              contact(
                "github_logo.png",
                "JoHyengGu",
                onClick: () async =>
                    await launchUrlString("https://github.com/JoHyeongGu"),
              ),
              contact(
                "gmail_logo.png",
                "whgudrn123@gmail.com",
                onClick: () async {
                  final email = "whgudrn123@gmail.com";
                  Clipboard.setData(ClipboardData(text: email));
                  final url = Mailto(to: [email]);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: MyColor.black.withValues(alpha: 0.7),
                      content: BasicText(
                        "이메일 주소가 복사되었습니다!",
                        color: Colors.white,
                        weight: FontWeight.w500,
                        size: 14,
                      ),
                    ),
                  );
                  await launchUrlString("$url");
                },
                // "mailto:whgudrn123@gmail.com",
              ),
            ],
          ),
          NextIcon(widget.controller),
          Center(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  widget.controller.nextPage(
                    duration: Duration(milliseconds: 600),
                    curve: Curves.easeInQuart,
                  );
                },
                child: Container(
                  color: Colors.transparent,
                  width: 50,
                  height: 33,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget contact(String logo, String txt, {GestureTapCallback? onClick}) {
    return GestureDetector(
      onTap: onClick,
      child: Row(
        spacing: 5,
        children: [
          Image.asset("assets/images/$logo", height: 17),
          BasicText(
            txt,
            weight: FontWeight.w900,
            line: TextDecoration.underline,
          ),
        ],
      ),
    );
  }
}

class NextIcon extends StatefulWidget {
  final PageController controller;
  const NextIcon(this.controller, {super.key});

  @override
  State<NextIcon> createState() => _NextIconState();
}

class _NextIconState extends State<NextIcon> {
  bool isDown = false;

  Future<void> animating() async {
    while (true) {
      await Future.delayed(Duration(milliseconds: 600));
      if (!mounted) break;
      setState(() {
        isDown = !isDown;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    animating();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      curve: Curves.easeInOutQuad,
      duration: Duration(milliseconds: 600),
      left: MediaQuery.of(context).size.width / 2 - 25,
      bottom: isDown ? -25 : -15,
      child: Transform(
        transform: Matrix4.rotationX(180),
        child: Icon(
          CupertinoIcons.triangle_fill,
          color: MyColor.brown.withValues(alpha: 0.5),
          size: 30,
        ),
      ),
    );
  }
}
