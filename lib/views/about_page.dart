import 'package:flutter/material.dart';
import 'package:portfolio/tool/color.dart';
import 'package:portfolio/tool/functions.dart';
import 'package:portfolio/widgets/skill_card.dart';
import 'package:portfolio/widgets/widgets.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageCard(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(
        vertical: 60,
        horizontal: MediaQuery.of(context).size.width > 500 ? 60 : 30,
      ),
      child: SingleChildScrollView(
        child: Column(
          spacing: 30,
          children: [
            BasicText("About Me", size: 40, weight: FontWeight.w500),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (MediaQuery.of(context).size.width > 800)
                  ProfileCard(width: 170),
                content(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget content(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth > 800 ? 50 : 0),
        child: Column(
          children: [
            if (screenWidth <= 800)
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: ProfileCard(
                  width: screenWidth * 0.6 >= 200 ? 200 : screenWidth * 0.6,
                ),
              ),
            profile(context),
            SizedBox(height: 30),
            skills(),
          ],
        ),
      ),
    );
  }

  Container section({required Widget child, String? title}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: MyColor.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(15),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            BasicText(title, size: 20, weight: FontWeight.w600),
          child,
        ],
      ),
    );
  }

  //#region Profile Section
  Widget profile(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BasicText(
              "Jo HyeongGu",
              size: screenWidth >= 500 ? 35 : screenWidth / 15,
            ),
            BasicText(
              "Full Stack Developer",
              size: screenWidth >= 500 ? 20 : screenWidth / 25,
            ),
            if (screenWidth <= 800)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: contact(context, size: 20),
              ),
          ],
        ),
        if (screenWidth > 800) contact(context),
      ],
    );
  }

  Widget contact(BuildContext context, {double size = 30}) {
    var data = {
      "github": {
        "widget": Image.asset("assets/images/github_logo.png", width: size),
        "onClick": gotoGithub,
      },
      "gmail": {
        "widget": Icon(Icons.mail_outlined, size: size * (45 / 33)),
        "onClick": () => gotoGmail(context),
      },
      "linkedIn": {
        "widget": Image.asset("assets/images/linkedIn_logo.png", width: size),
        "onClick": gotoLinkedIn,
      },
    };

    return Opacity(
      opacity: 0.7,
      child: Row(
        spacing: size * 15 / 33,
        children: data.entries
            .map(
              (e) => GestureDetector(
                onTap: e.value["onClick"] as GestureTapCallback,
                child: e.value["widget"] as Widget,
              ),
            )
            .toList(),
      ),
    );
  }
  //#endregion

  //#region Key Skills Section
  Widget skills() {
    var data = {
      "Unity": {"color": Color(0xff6e6e6e)},
      "Unreal": {"color": Color(0xff323232)},
      "Flutter": {
        "color": Color(0xff1dbaf9),
        "content": ["Web App", "Windows App", "Android"],
      },
      "Python": {
        "color": Color(0xff3d73a2),
        "content": ["Crawling", "Flask", "FastAPI"],
      },
      "MySQL": {"color": Color(0xff1a6796)},
      "MongoDB": {
        "color": Color(0xff08ae46),
        "content": ["Unity", "Unreal Engine 5"],
      },
      "NodeJS": {
        "color": Color(0xff85cc2f),
        "content": ["Unity", "Unreal Engine 5"],
      },
    };
    return section(
      title: "Skills",
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 5,
          children: data.entries
              .map(
                (e) =>
                    SkillCard(title: e.key, color: e.value["color"] as Color),
              )
              .toList(),
        ),
      ),
    );
  }

  //#endregion
}
