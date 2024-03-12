import 'dart:async';

import 'package:flame/components.dart';
import 'package:here_again/game_src/game.dart';
import 'package:here_again/overlays/game_snack_bar.dart';
import 'package:here_again/overlays/won_menu.dart';

import '../../overlays/task_button.dart';

class Plant extends SpriteAnimationComponent with HasGameRef<HereAgain> {
  Plant({position, size}) : super(position: position, size: size);

  late SpriteAnimation plantStill;
  late SpriteAnimation plantWatering;
  late int limit = 20;
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    plantStill = SpriteAnimation.fromFrameData(
        game.images.fromCache('Tasks/plant_still.png'),
        SpriteAnimationData.sequenced(
            amount: 1,
            stepTime: 0.1,
            textureSize: Vector2(32, 32),
            loop: true));
    plantWatering = SpriteAnimation.fromFrameData(
        game.images.fromCache('Tasks/plant_water_grow.png'),
        SpriteAnimationData.sequenced(
            amount: 10,
            stepTime: 0.1,
            textureSize: Vector2(32, 32),
            loop: false));
    animation = plantStill;
    limit += (gameRef.level == 15) ? 1 : 0;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    handlePlayerCollision();
    if (gameRef.taskComplete) _waterPlants();
    super.update(dt);
  }

  void handlePlayerCollision() {
    if (checkPlayerCollision()) {
      if (gameRef.itemsCollected < 1) {
        gameRef.gameSnackBar = "Need $limit Water Drops";
        gameRef.overlays.add(GameSnackBar.id);
      } else {
        gameRef.overlays.add(TaskButton.id);
      }
    } else {
      if (gameRef.overlays.activeOverlays.contains(TaskButton.id)) {
        gameRef.overlays.remove(TaskButton.id);
      }
      if (gameRef.overlays.activeOverlays.contains(GameSnackBar.id)) {
        gameRef.overlays.remove(GameSnackBar.id);
      }
    }
  }

  bool checkPlayerCollision() {
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

  void _waterPlants() {
    animation = plantWatering;
    animationTicker?.onComplete = () {
      gameRef.pauseEngine();
      gameRef.overlays.add(WonMenu.id);
    };
  }
}
