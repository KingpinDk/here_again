import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

class LuckyWheel extends StatefulWidget {
  const LuckyWheel({super.key});

  @override
  State<LuckyWheel> createState() => _LuckyWheelState();
}

class _LuckyWheelState extends State<LuckyWheel> {
  final chosen = BehaviorSubject<int>();
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
  List<Text> wheelList = [
    Text(
      "0 Water Drops",
      style: TextStyle(color: Colors.white, fontFamily: "Edo"),
    ),
    Text(
      "3 Water Drops",
      style: TextStyle(color: Colors.white, fontFamily: "Edo"),
    ),
    Text(
      "10 Water Drops",
      style: TextStyle(color: Colors.white, fontFamily: "Edo"),
    ),
    Text(
      "-10 Water Drops",
      style: TextStyle(color: Colors.white, fontFamily: "Edo"),
    ),
    Text(
      "Rare Card",
      style: TextStyle(color: Colors.white, fontFamily: "Edo"),
    ),
  ];
  List<Text> txtTitle = const [
    Text(
      "NO POVERTY",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    Text(
      "ZERO HUNGER",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    Text(
      "GOOD HEALTH & WELL-BEING",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    Text(
      "QUALITY EDUCATION",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    Text(
      "GENDER EQUALITY",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    Text(
      "CLEAN WATER & SANITATION",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    Text(
      "AFFORDABLE AND CLEAN ENERGY",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    Text(
      "DECENT WORK & ECONOMIC GROWTH",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    Text(
      "INDUSTRY, INNOVATION & INFRASTRUCTURE",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    Text(
      "REDUCE INEQUALITY",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    Text(
      "SUSTAINABLE CITIES & COMMUNITIES",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    Text(
      "RESPONSIBLE CONSUMPTION & PRODUCTION",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    Text(
      "CLIMATE ACTION",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    Text(
      "LIFE BELOW WATER",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    Text(
      "LIFE ON LAND",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    Text(
      "PEACE, JUSTICE & STRONG INSTITUTIONS",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    Text(
      "PARTNERSHIPS FOR THE GOAL",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    Text("PLAYING 4 THE PLANET",
        style: TextStyle(color: Color(0xFF4da2c4), fontWeight: FontWeight.bold))
  ];

  bool isTimerRunning = false;
  int secondsRemaining = 0;
  int getRandomCard(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min + 1);
  }

  void startTimer() {
    const oneDay = 15; // Number of seconds in a day
    setState(() {
      isTimerRunning = true;
      secondsRemaining = oneDay;
    });
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsRemaining < 1) {
          timer.cancel();
          todayCard = getRandomCard(0, txtTitle.length - 1);
          isTimerRunning = false;
        } else {
          secondsRemaining--;
        }
      });
    });
  }

  late var todayCard = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    chosen.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/images/Background/Background.png"),
              fit: BoxFit.fill,
            )),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [todaysCard(), fortuneWheel(), spinButton()],
            ),
          ),
          Positioned(
              top: 10,
              right: 50,
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFF9badb7),
                    border: Border.all(width: 5, color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(300))),
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
                        " 64",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Edo",
                            backgroundColor: Color(0xFF9badb7),
                            color: Color(0xFF211f30)),
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget spinButton() => Container(
      height: 30,
      width: 160,
      child: ElevatedButton(
        onPressed: () {
          if (!isTimerRunning) {
            chosen.add(Fortune.randomInt(0, txtTitle.length - 1));
            startTimer();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Center(
                child: Text(
                  "Come after ${(secondsRemaining ~/ 3600).toString().padLeft(2, '0')}:${((secondsRemaining % 3600) ~/ 60).toString().padLeft(2, '0')}:${(secondsRemaining % 60).toString().padLeft(2, '0')}",
                  style: TextStyle(
                      fontFamily: "Edo", fontSize: 30, color: Colors.red),
                ),
              ),
              backgroundColor: Colors.transparent,
            ));
          }
        },
        child: isTimerRunning
            ? Text(
                '${(secondsRemaining ~/ 3600).toString().padLeft(2, '0')}:${((secondsRemaining % 3600) ~/ 60).toString().padLeft(2, '0')}:${(secondsRemaining % 60).toString().padLeft(2, '0')}')
            : Text(
                'Spin',
                style: TextStyle(color: Colors.red, fontFamily: "Edo"),
              ),
      ));

  Widget fortuneWheel() => Container(
        height: 300,
        width: 300,
        child: FortuneWheel(
            animateFirst: false,
            selected: chosen.stream,
            onAnimationEnd: () {
              int val = chosen.value % 5;
              if (val == 0) {
                snack("Oops!! You got 0 Water Drops", context);
              } else if (val == 1) {
                snack("Wow!! You got 3 Water Drops", context);
              } else if (val == 2) {
                snack("Ultimate!! You got 10 Water Drops", context);
              } else if (val == 3) {
                snack("You got penalty of 10 Water Drops", context);
              } else if (val == 4) {
                snack("Amazing!! You got a Rare Card}", context);
              } else {
                snack("Some Error Occured!!", context);
              }
            },
            items: [
              for (var i = 0; i < wheelList.length; i++)
                if (i == wheelList.length - 1)
                  FortuneItem(
                      child: wheelList[i],
                      style: FortuneItemStyle(
                          borderColor: Colors.black87,
                          borderWidth: 2,
                          color: bgColor[1]))
                else if (i == 0)
                  FortuneItem(
                      child: wheelList[i],
                      style: FortuneItemStyle(
                          borderColor: Colors.black87,
                          borderWidth: 2,
                          color: bgColor[2]))
                else if (i == 1)
                  FortuneItem(
                      child: wheelList[i],
                      style: FortuneItemStyle(
                          borderColor: Colors.black87,
                          borderWidth: 2,
                          color: bgColor[3]))
                else if (i == 2)
                  FortuneItem(
                      child: wheelList[i],
                      style: FortuneItemStyle(
                          borderColor: Colors.black87,
                          borderWidth: 2,
                          color: bgColor[5]))
                else
                  FortuneItem(
                      child: wheelList[i],
                      style: FortuneItemStyle(
                          borderColor: Colors.black87,
                          borderWidth: 2,
                          color: bgColor[13]))
            ]),
      );

  Widget todaysCard() => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Today's Rare Card",
              style:
                  TextStyle(fontSize: 20, fontFamily: "Edo", color: Colors.red),
            ),
            Container(
              height: 250,
              width: 200,
              margin: EdgeInsets.all(10),
              child: InkWell(
                splashColor: bgColor[todayCard],
                onTap: () {
                  if (todayCard != 17)
                    launchUrl(Uri.parse(
                        "https://sdgs.un.org/goals/goal${todayCard + 1}"));
                  else
                    launchUrl(Uri.parse("https://www.playing4theplanet.org/"));
                },
                child: Card(
                  elevation: 5.0,
                  color: bgColor[todayCard],
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(child: txtTitle[todayCard]),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            "assets/images/Collectibles/goal${todayCard + 1}_menu_icon.jpg",
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  void snack(String str, BuildContext context) {
    final snackBar = SnackBar(
      content: Center(
        child: Text(
          str,
          style: TextStyle(fontFamily: "Edo", fontSize: 20, color: Colors.red),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
