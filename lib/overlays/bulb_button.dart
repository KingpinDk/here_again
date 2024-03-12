import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:here_again/game_src/game.dart';
import 'package:here_again/overlays/bulb_message.dart';
import 'package:here_again/overlays/help_message.dart';
import 'package:here_again/overlays/lost_menu.dart';
import 'package:here_again/overlays/pause_menu.dart';
import 'package:here_again/overlays/won_menu.dart';

class BulbButton extends StatelessWidget {
  static const String id = "bulbButton";
  final HereAgain gameRef;
  const BulbButton({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 21,
      left: 60,
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
            gameRef.overlays.add(BulbMessage.id);
            gameRef.overlays.remove(BulbButton.id);
          }
        },
        child: const Icon(
          Icons.info_rounded,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
