import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:here_again/overlays/help_button.dart';

import '../game_src/game.dart';

class HelpMessage extends StatelessWidget {
  static const String id = "helpMessage";
  final HereAgain gameRef;

  const HelpMessage({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    String helpTxt = gameRef.missions[gameRef.level - 1];
    return Center(
        child: SizedBox(
      height: 200,
      width: 500,
      child: Card(
          color: Colors.black45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset("assets/images/Facesets/dk.png"),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "DK",
                    style: TextStyle(
                        fontFamily: "Edo", fontSize: 20, color: Colors.red),
                  ),
                  Text(
                    helpTxt,
                    style: TextStyle(
                        fontFamily: "Edo", fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
              IconButton(
                  onPressed: () {
                    if (gameRef.isSfx) FlameAudio.play("btnClick.wav");
                    gameRef.overlays.remove(HelpMessage.id);
                    gameRef.overlays.add(HelpButton.id);
                    gameRef.resumeEngine();
                    if (gameRef.isMusic)
                      FlameAudio.bgm.play("21-Dungeon.wav", volume: 0.1);
                  },
                  icon: Icon(Icons.close_rounded))
            ],
          )),
    ));
  }
}
