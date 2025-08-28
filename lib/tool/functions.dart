import 'package:mailto/mailto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/tool/tool.dart';
import 'package:portfolio/widgets/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

gotoLink(String link) async {
  await launchUrlString(link);
}

var gotoGithub = () => gotoLink("https://github.com/JoHyeongGu");

var gotoLinkedIn = () => gotoLink("https://www.linkedin.com/in/johyeong9");

gotoGmail(BuildContext context) async {
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
}
