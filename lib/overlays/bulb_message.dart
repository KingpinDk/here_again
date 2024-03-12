import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import '../game_src/game.dart';
import 'bulb_button.dart';

class BulbMessage extends StatelessWidget {
  static const String id = "bulbMessage";
  final HereAgain gameRef;

  const BulbMessage({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    String ideaTxt = gameRef.hints[gameRef.level - 1];
    return Center(
        child: SizedBox(
      height: 100,
      width: 500,
      child: Card(
          color: Colors.black45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset("assets/images/Facesets/dk.png"),
              Column(
                children: [
                  Text(
                    "DK",
                    style: TextStyle(
                        fontFamily: "Edo", fontSize: 20, color: Colors.red),
                  ),
                  Text(
                    ideaTxt,
                    style: TextStyle(
                        fontFamily: "Edo", fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
              IconButton(
                  onPressed: () {
                    if (gameRef.isSfx) FlameAudio.play("btnClick.wav");
                    gameRef.overlays.remove(BulbMessage.id);
                    gameRef.overlays.add(BulbButton.id);
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
