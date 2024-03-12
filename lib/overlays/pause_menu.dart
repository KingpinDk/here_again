import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:here_again/app_src/levels.dart';
import 'package:here_again/game_src/Components/light.dart';
import 'package:here_again/overlays/pause_button.dart';
import 'package:here_again/overlays/won_menu.dart';

import '../game_src/game.dart';

class PauseMenu extends StatelessWidget {
  static const String id = "pauseMenu";
  final HereAgain gameRef;
  const PauseMenu({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 240,
        width: 380,
        child: Card(
          color: Colors.black,
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Stack(
            children: [
              Center(
                child: ClipRect(
                  child: Image.asset(
                    'assets/images/Background/Gallery.png',
                    height: 360,
                    width: 640,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () async {
                          if (gameRef.isSfx) FlameAudio.play("btnClick.wav");
                          if (gameRef.level == 7 && checkPlayerPos()) {
                            gameRef.overlays.remove(PauseMenu.id);
                            gameRef.overlays.add(PauseButton.id);
                            gameRef.resumeEngine();
                            if (gameRef.isMusic)
                              FlameAudio.bgm
                                  .play("21-Dungeon.wav", volume: 0.1);
                            gameRef.light.current = LightState.lightOff;
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            gameRef.pauseEngine();
                            gameRef.overlays.add(WonMenu.id);
                          } else {
                            gameRef.overlays.remove(PauseMenu.id);
                            gameRef.overlays.add(PauseButton.id);
                            gameRef.resumeEngine();
                            if (gameRef.isMusic)
                              FlameAudio.bgm
                                  .play("21-Dungeon.wav", volume: 0.1);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/Controls/playmarker.png",
                              height: 20,
                              width: 20,
                            ),
                            Text(
                              "Resume",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: "Edo",
                                  fontSize: 30),
                            )
                          ],
                        )),
                    TextButton(
                        onPressed: () {
                          if (gameRef.isMusic) FlameAudio.bgm.stop();
                          gameRef.overlays.remove(PauseMenu.id);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LevelsScreen(prefs: gameRef.prefs)));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/Controls/close.png",
                              height: 20,
                              width: 20,
                            ),
                            Text(
                              "Quit",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: "Edo",
                                  fontSize: 30),
                            )
                          ],
                        )),
                  ],
                ),
              )
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
        ),
      ),
    );
  }

  bool checkPlayerPos() {
    final playerPos = gameRef.player.position;

    final playerX = playerPos.x;
    final playerY = playerPos.y;

    return ((playerX >= 910) &&
        (playerX <= 1010) &&
        (playerY >= 589) &&
        (playerY <= 680));
  }
}
