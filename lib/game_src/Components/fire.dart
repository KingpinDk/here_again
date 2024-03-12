import 'dart:async';

import 'package:flame/components.dart';
import 'package:here_again/game_src/Components/player.dart';
import 'package:here_again/game_src/game.dart';
import 'package:here_again/overlays/task_button.dart';

import '../../overlays/won_menu.dart';

class Fire extends SpriteAnimationComponent with HasGameRef<HereAgain> {
  Fire({position, size})
      : super(position: position, size: size, removeOnFinish: true);
  late Player player;
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    player = gameRef.player;
    _loadFireAnimation();
    return super.onLoad();
  }

  void _loadFireAnimation() {
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache("Tasks/fire_smoke.png"),
        SpriteAnimationData.sequenced(
            amount: 19, stepTime: 0.01, textureSize: Vector2.all(96)));
  }

  @override
  void update(double dt) {
    // TODO: implement update
    _handleFirePlayerCollision();
    putOutFire();
    super.update(dt);
  }

  bool checkFirePlayerCollision() {
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

  bool checkFirePlayerDeathCollision() {
    final playerHitbox = player.playerHitBox;

    final playerX = player.position.x + playerHitbox.offsetX;
    final playerY = player.position.y + playerHitbox.offsetY;
    final playerHeight = playerHitbox.height;
    final playerWidth = playerHitbox.width;

    final fireHeight = height - 48;
    final fireWidth = width - 64;

    final fireX = position.x + 32;
    final fireY = position.y + 48;

    return ((playerY < fireY + fireHeight) &&
        (playerHeight + playerY > fireY) &&
        (playerX < fireX + fireWidth) &&
        (playerWidth + playerX > fireX));
  }

  void _handleFirePlayerCollision() {
    if (checkFirePlayerDeathCollision()) {
      if (gameRef.overlays.activeOverlays.contains(TaskButton.id)) {
        gameRef.overlays.remove(TaskButton.id);
      }
      player.isDead = true;
      player.velocity.x = 0;
      player.velocity.y = 0;
    } else if (checkFirePlayerCollision() && !player.isDead) {
      gameRef.overlays.add(TaskButton.id);
    } else {
      if (gameRef.overlays.activeOverlays.contains(TaskButton.id)) {
        gameRef.overlays.remove(TaskButton.id);
      }
    }
  }

  Future<void> putOutFire() async {
    if (gameRef.taskComplete == true) {
      animation = SpriteAnimation.fromFrameData(
          game.images.fromCache("Tasks/fire_extinguished.png"),
          SpriteAnimationData.sequenced(
              amount: 5,
              stepTime: 0.01,
              textureSize: Vector2.all(96),
              loop: false));
      gameRef.taskComplete = false;
      await Future.delayed(const Duration(milliseconds: 400));
      removeFromParent();
      gameRef.pauseEngine();
      gameRef.overlays.add(WonMenu.id);
    }
  }
}
