import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:here_again/overlays/bulb_message.dart';
import 'package:here_again/overlays/help_message.dart';
import 'package:here_again/overlays/pause_menu.dart';
import 'package:here_again/overlays/won_menu.dart';

import '../game_src/game.dart';
import 'lost_menu.dart';

class HelpButton extends StatelessWidget {
  static const String id = "helpButton";
  final HereAgain gameRef;
  const HelpButton({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 21,
      left: 21,
      child: TextButton(
        child: Icon(
          Icons.help,
          color: Colors.white,
          size: 32,
        ),
        onPressed: () {
          if (!gameRef.overlays.activeOverlays.contains(HelpMessage.id) &&
              !gameRef.overlays.activeOverlays.contains(BulbMessage.id) &&
              !gameRef.overlays.activeOverlays.contains(LostMenu.id) &&
              !gameRef.overlays.activeOverlays.contains(PauseMenu.id) &&
              !gameRef.overlays.activeOverlays.contains(WonMenu.id)) {
            if (gameRef.isSfx) FlameAudio.play("btnClick.wav");
            gameRef.pauseEngine();
            if (gameRef.isMusic) FlameAudio.bgm.stop();
            gameRef.overlays.add(HelpMessage.id);
            gameRef.overlays.remove(HelpButton.id);
          }
        },
      ),
    );
  }
}
