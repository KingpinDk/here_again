import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import '../game_src/game.dart';

class TaskButton extends StatelessWidget {
  static const String id = "taskButton";
  final HereAgain gameRef;
  const TaskButton({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    final String msgTxt = gameRef.tasks[gameRef.level - 1];

    return Align(
      alignment: Alignment.centerRight,
      child: OutlinedButton(
        onPressed: () async {
          gameRef.taskComplete = true;
          if (gameRef.isSfx) FlameAudio.play("btnClick.wav");
          if (gameRef.overlays.activeOverlays.contains(TaskButton.id))
            gameRef.overlays.remove(TaskButton.id);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white38),
        ),
        child: Text(
          msgTxt,
          style:
              TextStyle(fontFamily: "Edo", fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
