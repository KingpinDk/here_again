import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:here_again/app_src/levels.dart';

import '../game_src/game.dart';

class LostMenu extends StatelessWidget {
  static const String id = "LostMenu";
  static String msg = "";
  final HereAgain gameRef;
  const LostMenu({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    if (gameRef.isMusic) FlameAudio.bgm.stop();
    if (gameRef.isSfx) FlameAudio.play("gameLost2.wav", volume: 1);
    final String msgTxt;
    final String assetTxt;

    if (msg == "") {
      if (gameRef.character == "Paari" && gameRef.player.moveSpeed > 225) {
        assetTxt = "greeny";
        msgTxt = "If You Ride Like Lightning,\nYou're Gonna Crash Like Thunder";
      } else if (gameRef.level == 1) {
        assetTxt = "piggy";
        msgTxt = "You are Slower than me!";
      } else if (gameRef.level == 2 ||
          gameRef.level == 4 ||
          gameRef.level == 8 ||
          gameRef.level == 6) {
        assetTxt = "greeny";
        msgTxt = "You Can't even dodge saws?!";
      } else if (gameRef.level == 3) {
        assetTxt = "greeny";
        msgTxt = "huh?! what a failure";
      } else if (gameRef.level == 14 || gameRef.level == 15) {
        assetTxt = "sandy";
        msgTxt = "Gambare Gambare (try harder)!!";
      } else {
        assetTxt = "reddy";
        msgTxt = "Hasta la Vista baby!!";
      }
    } else {
      assetTxt = "sandy";
      msgTxt = msg;
    }
    return Center(
        child: SizedBox(
      height: 200,
      width: 500,
      child: Card(
          color: Colors.black45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/Facesets/$assetTxt.png",
                  height: 48,
                  width: 48,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Game Lost",
                    style: TextStyle(
                        fontFamily: "Edo", fontSize: 20, color: Colors.red),
                  ),
                  Text(
                    msgTxt,
                    style: TextStyle(
                        fontFamily: "Edo", fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
              IconButton(
                  onPressed: () {
                    if (gameRef.isSfx) FlameAudio.play("btnClick.wav");
                    gameRef.overlays.remove(LostMenu.id);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            LevelsScreen(prefs: gameRef.prefs)));
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                  ))
            ],
          )),
    ));
  }
}
