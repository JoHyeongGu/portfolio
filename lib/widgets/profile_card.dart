import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:portfolio/tool/color.dart';

class ProfileCard extends StatefulWidget {
  final double width;
  final double ratio;
  const ProfileCard({super.key, this.width = 130, this.ratio = 160 / 130});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard>
    with TickerProviderStateMixin {
  bool toggleOn = true;
  bool isPixel = true;
  bool isClicked = false;
  String loadGif = "";
  late GifController gifController;

  @override
  void initState() {
    super.initState();
    gifController = GifController(vsync: this);
  }

  @override
  void dispose() {
    gifController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: triggerToggle,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: Colors.black, // loadGif == "" ? MyColor.brown : Colors.black,
          borderRadius: BorderRadius.circular(15),
          border: BoxBorder.symmetric(
            vertical: BorderSide(color: MyColor.white, width: 8),
            horizontal: BorderSide(color: MyColor.white, width: 10),
          ),
        ),
        height: widget.width * widget.ratio,
        width: widget.width,
        padding: EdgeInsets.all(5).copyWith(bottom: 0),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: Image.asset(
                // width: widget.width,
                height: widget.width * widget.ratio - 25,
                "assets/images/${isPixel ? "pixel_jhg.png" : "real_jhg.png"}",
              ),
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: !isClicked ? 0 : 1,
              child: Gif(
                fps: 80,
                controller: gifController,
                autostart: Autostart.once,
                image: AssetImage(
                  loadGif == ""
                      ? "assets/images/${isPixel ? "pixel_jhg.png" : "real_jhg.png"}"
                      : "assets/images/$loadGif.gif",
                ),
              ),
            ),
            toggleButton(),
          ],
        ),
      ),
    );
  }

  Widget toggleButton() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      width: 30,
      height: 15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: toggleOn ? Colors.amberAccent : Colors.greenAccent,
      ),
      child: AnimatedAlign(
        alignment: toggleOn ? Alignment.centerLeft : Alignment.centerRight,
        duration: Duration(milliseconds: 100),
        child: Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [BoxShadow(blurRadius: 1, spreadRadius: 0.3)],
          ),
        ),
      ),
    );
  }

  void triggerToggle() async {
    if (isClicked || gifController.status == AnimationStatus.forward) return;
    setState(() {
      isClicked = true;
    });
    setState(() {
      toggleOn = !toggleOn;
      loadGif = isPixel ? "pixel_to_real" : "real_to_pixel";
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      isPixel = !isPixel;
    });
    await Future.delayed(Duration(milliseconds: 50));
    setState(() {
      isClicked = false;
      loadGif = "";
    });
  }
}
