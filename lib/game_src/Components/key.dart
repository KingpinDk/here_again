import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:here_again/game_src/game.dart';

class Key extends SpriteAnimationComponent with HasGameRef<HereAgain> {
  bool isVisible;
  Key({position, size, required this.isVisible})
      : super(position: position, size: Vector2(24, 24));
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    priority = 4999999987654;
    if (isVisible)
      animation =
          _effectAnimation("Items/Key/key", 4, true, Vector2(16, 9), 0.1);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    handlePlayerKeyInteraction();
    super.update(dt);
  }

  SpriteAnimation _effectAnimation(
      String state, int amt, bool loop, Vector2 size, double stepTime) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('$state.png'),
        SpriteAnimationData.sequenced(
            amount: amt, stepTime: stepTime, textureSize: size, loop: loop));
  }

  void handlePlayerKeyInteraction() async {
    if (_checkPlayerKeyCollision() && !gameRef.keyCollected) {
      if (gameRef.isSfx) {
        FlameAudio.play('pickupWaterDrop.wav');
      }

      removeOnFinish = true;

      animation = _effectAnimation(
          'Items/Fruits/Collected', 6, false, Vector2(32, 32), 0.1);
      gameRef.itemsCollected++;
      gameRef.keyCollected = true;
    }
  }

  bool _checkPlayerKeyCollision() {
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
}
