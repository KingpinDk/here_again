import 'dart:async';

import 'package:flame/components.dart';
import 'package:here_again/game_src/game.dart';
import 'package:here_again/overlays/task_button.dart';

import '../../overlays/won_menu.dart';

class Land extends SpriteAnimationComponent with HasGameRef<HereAgain> {
  Land({position, size}) : super(position: position, size: size);
  late SpriteAnimation plantGrowth;

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    plantGrowth = SpriteAnimation.fromFrameData(
        game.images.fromCache("Tasks/plant_grow.png"),
        SpriteAnimationData.sequenced(
            amount: 10,
            stepTime: 0.09,
            textureSize: Vector2.all(32),
            loop: false));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    _handlePlayerOnLand();
    _plantTheSeed();
    super.update(dt);
  }

  void _handlePlayerOnLand() {
    if (checkPlayerOnLand()) {
      gameRef.overlays.add(TaskButton.id);
    } else {
      if (gameRef.overlays.activeOverlays.contains(TaskButton.id))
        gameRef.overlays.remove(TaskButton.id);
    }
  }

  bool checkPlayerOnLand() {
    final player = gameRef.player;
    final playerHitbox = player.playerHitBox;

    final playerX = player.position.x + playerHitbox.offsetX;
    final playerY = player.position.y + playerHitbox.offsetY;
    final playerHeight = playerHitbox.height;
    final playerWidth = playerHitbox.width;

    return ((playerY < position.y + height) &&
        (playerHeight + playerY > position.y) &&
        (playerX < position.x + width) &&
        (playerWidth + playerX > position.x));
  }

  Future<void> _plantTheSeed() async {
    if (gameRef.taskComplete) {
      animation = plantGrowth;
      await Future.delayed(const Duration(milliseconds: 1000));
      gameRef.taskComplete = false;
      gameRef.pauseEngine();
      gameRef.overlays.add(WonMenu.id);
    }
  }
}
