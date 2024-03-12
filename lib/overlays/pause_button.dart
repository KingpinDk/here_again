import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:here_again/game_src/game.dart';
import 'package:here_again/overlays/pause_menu.dart';
import 'package:here_again/overlays/won_menu.dart';

import 'bulb_message.dart';
import 'help_message.dart';
import 'lost_menu.dart';

class PauseButton extends StatelessWidget {
  static const String id = "pauseButton";
  final HereAgain gameRef;
  const PauseButton({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.only(top: 21, right: 21),
        child: TextButton(
          onPressed: () {
            if (!gameRef.overlays.activeOverlays.contains(HelpMessage.id) &&
                !gameRef.overlays.activeOverlays.contains(BulbMessage.id) &&
                !gameRef.overlays.activeOverlays.contains(LostMenu.id) &&
                !gameRef.overlays.activeOverlays.contains(PauseMenu.id) &&
                !gameRef.overlays.activeOverlays.contains(WonMenu.id)) {
              if (gameRef.isSfx) FlameAudio.play("btnClick.wav");
              gameRef.pauseEngine();
              if (gameRef.isMusic) FlameAudio.bgm.stop();
              gameRef.overlays.add(PauseMenu.id);
              gameRef.overlays.remove(PauseButton.id);
            }
          },
          child: Image.asset(
            "assets/images/Controls/pause_white.png",
            height: 32,
            width: 32,
          ),
        ),
      ),
    );
  }
}
