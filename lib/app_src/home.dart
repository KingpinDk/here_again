import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:here_again/app_src/collectibles.dart';
import 'package:here_again/app_src/levels.dart';
import 'package:here_again/app_src/lucky_wheel.dart';
import 'package:window_size/window_size.dart';

import 'characters.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<int> cardsCount = List.filled(18, 0);

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        setWindowTitle('Here Again');

        setWindowMinSize(const Size(640, 360));
      }
    }
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("assets/images/Background/Background.png"),
                fit: BoxFit.fill,
              )),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 50, top: 70),
                child: Text(
                  "Here Again",
                  style: TextStyle(
                      color: Colors.red, fontSize: 100, fontFamily: 'Edo'),
                ),
              ),
            ),
            Positioned(
                bottom: 10,
                right: 50,
                child: TextButton(
                  onPressed: () => goToPage(context, LevelsScreen()),
                  style: ButtonStyle(
                      surfaceTintColor:
                          MaterialStateProperty.all(Colors.white30)),
                  child: Text(
                    "Play",
                    style: TextStyle(
                        color: Colors.red, fontSize: 50, fontFamily: 'Edo'),
                  ),
                )),
            Positioned(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customIconButton(() => goToPage(context, Character()),
                    "assets/images/Menu/Buttons/malala_character_button.png"),
                customIconButton(() => goToPage(context, LuckyWheel()),
                    "assets/images/Menu/Buttons/lucky_wheel.png"),
                customIconButton(() => goToPage(context, Collectibles()),
                    "assets/images/Menu/Buttons/cards_button.png"),
                customIconButton(
                    () {}, "assets/images/Menu/Buttons/leaderboard_button.png"),
                customIconButton(
                    () {}, "assets/images/Menu/Buttons/settings_button.png")
              ],
            )),
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
        ));
  }

  void goToPage(BuildContext context, Widget nextPage) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => nextPage));
  }

  Widget customIconButton(onPressed, path) {
    return TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.white30),
        ),
        onPressed: onPressed,
        child: Container(
          height: 50,
          width: 50,
          child: Ink.image(image: AssetImage(path), fit: BoxFit.fill),
        ));
  }
}
