import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:here_again/app_src/levels.dart';

import '../game_src/game.dart';

class WonMenu extends StatelessWidget {
  static const String id = "WonMenu";
  final HereAgain gameRef;

  const WonMenu({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    if (gameRef.isMusic) FlameAudio.bgm.stop();
    if (gameRef.isSfx) FlameAudio.play("gameWon.wav");
    final String msgTxt;
    final String assetTxt;
    if (gameRef.level == 3) {
      msgTxt = "Three victories\ndon't make you\na conqueror!!";
      assetTxt = "sandy";
    } else if (gameRef.level == 5 || gameRef.level == 11) {
      msgTxt = "Great now do\nit in real life!!";
      assetTxt = "dk";
    } else if (gameRef.level == 6) {
      msgTxt = "Superb!! now off the fan above\nyou which u dont really need";
      assetTxt = "dk";
    } else if (gameRef.level == 8 || gameRef.level == 9) {
      msgTxt = "Methuselah!! you found the seed";
      assetTxt = "dk";
    } else if (gameRef.level == 10) {
      msgTxt =
          "Methuselah is the nickname of a\nplant that germinated after 2000 years";
      assetTxt = "dk";
    } else if (gameRef.level == 1 || gameRef.level == 2) {
      msgTxt = "Buddy u stopped air pollution";
      assetTxt = "dk";
    } else if (gameRef.level == 4) {
      msgTxt = "Water is important\nso don't waste";
      assetTxt = "dk";
    } else if (gameRef.level == 15) {
      msgTxt = "It's ur perfect victory";
      assetTxt = "dk";
    } else {
      msgTxt = "Game won but what about in real life?";
      assetTxt = "dk";
    }
    return Center(
        child: SizedBox(
      height: 200,
      width: 500,
      child: Card(
          color: Colors.black45,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/Facesets/$assetTxt.png"),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Game Won",
                        style: TextStyle(
                            fontFamily: "Edo", fontSize: 20, color: Colors.red),
                      ),
                      Text(
                        msgTxt,
                        style: TextStyle(
                            fontFamily: "Edo",
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () async {
                        if (gameRef.isSfx) FlameAudio.play("btnClick.wav");
                        int waterDrops =
                            await gameRef.prefs.getInt("waterDrops") ?? 30;
                        gameRef.prefs.setInt("waterDrops", waterDrops + 10);
                        gameRef.overlays.remove(WonMenu.id);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) =>
                                LevelsScreen(prefs: gameRef.prefs)));
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white38,
                      ))
                ],
              ),
              Text(
                "You Got 10 water drops",
                style: TextStyle(
                    fontFamily: "Edo", fontSize: 20, color: Colors.red),
              )
            ],
          )),
    ));
  }
}
