import 'dart:io';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:here_again/app_src/collectibles.dart';
import 'package:here_again/app_src/lucky_wheel.dart';
import 'package:here_again/app_src/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_size/window_size.dart';

import 'characters.dart';
import 'levels.dart';

class Home extends StatefulWidget {
  SharedPreferences prefs;
  Home({super.key, required this.prefs});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<int> cardsCount = List.filled(18, 0);
  late bool isMusic, isSfx, isJoystick, isPaari;
  late int waterDrops;
  @override
  Widget build(BuildContext context) {
    isMusic = widget.prefs.getBool("isMusic") ?? false;
    isSfx = widget.prefs.getBool("isSfx") ?? false;
    isJoystick = widget.prefs.getBool("isJoystick") ?? false;
    isPaari = widget.prefs.getBool("isPaari") ?? true;

    waterDrops = widget.prefs.getInt("waterDrops") ?? 30;

    if (isMusic)
      FlameAudio.bgm.play("13-Mystical.wav", volume: 0.5);
    else
      FlameAudio.bgm.stop();

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
            screenBackground(),
            gameTitle(),
            playGameBtn(),
            sideBarBtns(),
            waterScore(),
          ],
        ));
  }

  void goToPage(BuildContext context, Widget nextPage) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => nextPage));
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

  Widget playGameBtn() {
    return Positioned(
        bottom: 10,
        right: 50,
        child: TextButton(
            onPressed: () {
              if (isSfx) FlameAudio.play("menuBtnClick.wav");
              goToPage(
                  context,
                  LevelsScreen(
                    prefs: widget.prefs,
                  ));
            },
            style: ButtonStyle(
                surfaceTintColor: MaterialStateProperty.all(Colors.white30)),
            child: const Text(
              "Play",
              style:
                  TextStyle(color: Colors.red, fontSize: 50, fontFamily: 'Edo'),
            )));
  }

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
                " $waterDrops",
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

  Widget sideBarBtns() => Positioned(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          customIconButton(() {
            if (isSfx) FlameAudio.play("menuBtnClick.wav");
            goToPage(
                context,
                Character(
                  prefs: widget.prefs,
                ));
          },
              (isPaari)
                  ? "assets/images/Menu/Buttons/paari_character_button.png"
                  : "assets/images/Menu/Buttons/greta_character_button.png"),
          customIconButton(() {
            if (isSfx) FlameAudio.play("menuBtnClick.wav");
            goToPage(context, LuckyWheel(prefs: widget.prefs));
          }, "assets/images/Menu/Buttons/lucky_wheel.png"),
          customIconButton(() {
            if (isSfx) FlameAudio.play("menuBtnClick.wav");
            goToPage(context, Collectibles(prefs: widget.prefs));
          }, "assets/images/Menu/Buttons/cards_button.png"),
          customIconButton(() {
            if (isSfx) FlameAudio.play("menuBtnClick.wav");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Center(
                    child: Text(
                  "Leader board and Messaging Coming soon!!",
                  style: TextStyle(
                      fontFamily: "Edo", fontSize: 20, color: Colors.red),
                )),
                backgroundColor: Colors.transparent));
          }, "assets/images/Menu/Buttons/leaderboard_button.png"),
          customIconButton(() {
            if (isSfx) FlameAudio.play("menuBtnClick.wav");
            goToPage(
                context,
                Settings(
                  prefs: widget.prefs,
                ));
          }, "assets/images/Menu/Buttons/settings_button.png")
        ],
      ));

  Widget screenBackground() => Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/Background/Background.png"),
          fit: BoxFit.fill,
        )),
      );

  Widget gameTitle() => Center(
        child: Container(
          margin: const EdgeInsets.only(bottom: 50, top: 70),
          child: const Text(
            "Here Again",
            style:
                TextStyle(color: Colors.red, fontSize: 100, fontFamily: 'Edo'),
          ),
        ),
      );
}
