import 'dart:io';

import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:here_again/game_src/Components/player.dart';
import 'package:here_again/game_src/game.dart';
import 'package:here_again/overlays/bulb_button.dart';
import 'package:here_again/overlays/bulb_message.dart';
import 'package:here_again/overlays/game_snack_bar.dart';
import 'package:here_again/overlays/lost_menu.dart';
import 'package:here_again/overlays/pause_button.dart';
import 'package:here_again/overlays/pause_menu.dart';
import 'package:here_again/overlays/task_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../overlays/help_button.dart';
import '../overlays/help_message.dart';
import '../overlays/won_menu.dart';
import 'home.dart';

class LevelsScreen extends StatefulWidget {
  SharedPreferences prefs;

  LevelsScreen({super.key, required this.prefs});

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  final int enabled = 15;

  late bool isMusic, isSfx, isJoystick, isPaari;
  late int waterDrops;

  @override
  Widget build(BuildContext context) {
    isMusic = widget.prefs.getBool("isMusic") ?? false;
    isSfx = widget.prefs.getBool("isSfx") ?? false;
    isJoystick = widget.prefs.getBool("isJoystick") ?? false;
    isPaari = widget.prefs.getBool("isPaari") ?? true;
    waterDrops = widget.prefs.getInt("waterDrops") ?? 30;
    return Scaffold(
        body: Stack(
      children: [
        screenBackground(),
        LevelGrid(context),
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

  Widget screenBackground() => Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/Background/Background.png"),
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

  Widget LevelGrid(context) {
    final List<int> levels = List.generate(21, (index) => index + 1);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(30),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemCount: 21,
      itemBuilder: (context, index) {
        final level = levels[index];
        return Container(
          margin: EdgeInsets.all(30),
          child: ElevatedButton(
            onPressed: () async {
              if (isSfx) FlameAudio.play("menuBtnClick.wav");
              if (waterDrops >= 5) {
                if (enabled >= level) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Center(
                          child: Text(
                        "Entry fee 5 water drops",
                        style: TextStyle(
                            fontFamily: "Edo", fontSize: 20, color: Colors.red),
                      )),
                      backgroundColor: Colors.transparent));
                  waterDrops -= 5;
                  widget.prefs.setInt("waterDrops", waterDrops);
                  await Future.delayed(Duration(seconds: 1));
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GameWidget(
                              initialActiveOverlays: [
                                PauseButton.id,
                                BulbButton.id,
                                HelpButton.id
                              ],
                              overlayBuilderMap: {
                                PauseButton.id:
                                    (BuildContext context, HereAgain gameRef) =>
                                        PauseButton(
                                          gameRef: gameRef,
                                        ),
                                PauseMenu.id:
                                    (BuildContext context, HereAgain gameRef) =>
                                        PauseMenu(
                                          gameRef: gameRef,
                                        ),
                                BulbButton.id:
                                    (BuildContext context, HereAgain gameRef) =>
                                        BulbButton(
                                          gameRef: gameRef,
                                        ),
                                BulbMessage.id:
                                    (BuildContext context, HereAgain gameRef) =>
                                        BulbMessage(
                                          gameRef: gameRef,
                                        ),
                                HelpButton.id:
                                    (BuildContext context, HereAgain gameRef) =>
                                        HelpButton(
                                          gameRef: gameRef,
                                        ),
                                HelpMessage.id:
                                    (BuildContext context, HereAgain gameRef) =>
                                        HelpMessage(
                                          gameRef: gameRef,
                                        ),
                                LostMenu.id:
                                    (BuildContext context, HereAgain gameRef) =>
                                        LostMenu(
                                          gameRef: gameRef,
                                        ),
                                WonMenu.id:
                                    (BuildContext context, HereAgain gameRef) =>
                                        WonMenu(
                                          gameRef: gameRef,
                                        ),
                                TaskButton.id:
                                    (BuildContext context, HereAgain gameRef) =>
                                        TaskButton(gameRef: gameRef),
                                GameSnackBar.id:
                                    (BuildContext context, HereAgain gameRef) =>
                                        GameSnackBar(gameRef: gameRef),
                              },
                              game: HereAgain(
                                  isJoy: isJoystick,
                                  prefs: widget.prefs,
                                  isMusic: isMusic,
                                  isSfx: isSfx,
                                  player: Player(
                                      character: (isPaari) ? "Paari" : "Greta"),
                                  height: height,
                                  width: width,
                                  level: level,
                                  character: (isPaari) ? "Paari" : "Greta",
                                  isMobile: (!kIsWeb) &&
                                      (Platform.isAndroid || Platform.isIOS),
                                  isPc: (kIsWeb) ||
                                      (Platform.isAndroid ||
                                          Platform.isIOS)))));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Center(
                          child: Text(
                        "Coming soon! in the alpha version",
                        style: TextStyle(
                            fontFamily: "Edo", fontSize: 20, color: Colors.red),
                      )),
                      backgroundColor: Colors.transparent));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Center(
                        child: Text(
                      "Not Enough Water Drops",
                      style: TextStyle(
                          fontFamily: "Edo", fontSize: 20, color: Colors.red),
                    )),
                    backgroundColor: Colors.transparent));
              }
            },
            child: (enabled >= level)
                ? Image.asset(
                    "assets/images/Menu/Levels/$level.png",
                    height: 50,
                    width: 50,
                  )
                : Image.asset(
                    "assets/images/Menu/Levels/locked.png",
                    height: 50,
                    width: 50,
                  ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white38,
              shadowColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(300),
              ),
            ),
          ),
        );
      },
    );
  }
}
