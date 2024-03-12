import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home.dart';

class Collectibles extends StatefulWidget {
  SharedPreferences prefs;
  Collectibles({super.key, required this.prefs});

  @override
  State<Collectibles> createState() => _CollectiblesState();
}

class _CollectiblesState extends State<Collectibles> {
  late bool isMusic, isSfx, isJoystick, isPaari;
  late int waterDrop;

  @override
  Widget build(BuildContext context) {
    isMusic = widget.prefs.getBool("isMusic") ?? false;
    isSfx = widget.prefs.getBool("isSfx") ?? false;
    isPaari = widget.prefs.getBool("isPaari") ?? true;
    waterDrop = widget.prefs.getInt("waterDrop") ?? 30;
    return Scaffold(
        body: Stack(
      children: [
        screenBackground(),
        GridView.builder(
          padding: EdgeInsets.all(50),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: 18,
          itemBuilder: (BuildContext context, int index) {
            return Cards(index, context);
          },
        ),
        waterScore(),
        backButton(context),
      ],
    ));
  }

  Widget backButton(BuildContext context) => Positioned(
      top: 10,
      left: 10,
      child: TextButton(
          onPressed: () {
            if (isSfx) FlameAudio.play("menuBtnClick.wav");
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Home(prefs: widget.prefs)));
          },
          child: Image.asset(
            "assets/images/Controls/close.png",
            width: 32,
            height: 32,
          )));

  Widget Cards(int index, BuildContext context) {
    List<Color> bgColor = const [
      Color(0xFFea142d),
      Color(0xFFe09f29),
      Color(0xFF4a9c3e),
      Color(0xFFc30a15),
      Color(0xFFdd3f24),
      Color(0xFF0cbbea),
      Color(0xFFfebe09),
      Color(0xFF9a1137),
      Color(0xFFf66917),
      Color(0xFFcb0c4c),
      Color(0xFFf89d0e),
      Color(0xFFaf8d22),
      Color(0xFF41743e),
      Color(0xFF138ed2),
      Color(0xFF4aba32),
      Color(0xFF13628d),
      Color(0xFF1a3f6c),
      Color(0xFFfefffd)
    ];

    List<Text> txtTitle = const [
      Text(
        "1 NO POVERTY",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      Text(
        "2 ZERO HUNGER",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      Text(
        "3 GOOD HEALTH & WELL-BEING",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      Text(
        "4 QUALITY EDUCATION",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      Text(
        "5 GENDER EQUALITY",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      Text(
        "6 CLEAN WATER & SANITATION",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      Text(
        "7 AFFORDABLE AND CLEAN ENERGY",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      Text(
        "8 DECENT WORK & ECONOMIC GROWTH",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      Text(
        "9 INDUSTRY, INNOVATION & INFRASTRUCTURE",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      Text(
        "10 REDUCE INEQUALITY",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      Text(
        "11 SUSTAINABLE CITIES & COMMUNITIES",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      Text(
        "12 RESPONSIBLE CONSUMPTION & PRODUCTION",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      Text(
        "13 CLIMATE ACTION",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      Text(
        "14 LIFE BELOW WATER",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      Text(
        "15 LIFE ON LAND",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      Text(
        "16 PEACE, JUSTICE & STRONG INSTITUTIONS",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      Text(
        "17 PARTNERSHIPS FOR THE GOAL",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      Text("18 PLAYING 4 THE PLANET",
          style:
              TextStyle(color: Color(0xFF4da2c4), fontWeight: FontWeight.bold))
    ];

    return Container(
        margin: EdgeInsets.all(10),
        child: InkWell(
          splashColor: bgColor[index],
          onTap: () {
            if (isSfx) FlameAudio.play("menuBtnClick.wav");
            if (index != 17)
              launchUrl(
                  Uri.parse("https://sdgs.un.org/goals/goal${index + 1}"));
            else
              launchUrl(Uri.parse("https://www.playing4theplanet.org/"));
          },
          child: Card(
            elevation: 5.0,
            color: bgColor[index],
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: txtTitle[index]),
                  Image.asset(
                    "assets/images/Collectibles/goal${index + 1}_menu_icon.jpg",
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    "Cards Collected $index",
                    style: TextStyle(
                        fontSize: 15,
                        color: (index != 17) ? Colors.white : Color(0xFF4da2c4),
                        fontFamily: "Edo"),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget screenBackground() => Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
            "assets/images/Background/Background.png",
          ),
          fit: BoxFit.fill,
        )),
      );

  Widget waterScore() => Positioned(
      top: 10,
      right: 50,
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xFF9badb7),
            border: Border.all(width: 5, color: Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(300))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.asset(
                "assets/images/Menu/Buttons/water_drop.png",
                width: 40,
                height: 40,
              ),
              Text(
                " $waterDrop",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Edo",
                    backgroundColor: Color(0xFF9badb7),
                    color: Color(0xFF211f30)),
              ),
            ],
          ),
        ),
      ));
}
