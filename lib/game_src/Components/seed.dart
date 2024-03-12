import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:here_again/game_src/game.dart';
import 'package:here_again/overlays/won_menu.dart';

class Seed extends SpriteAnimationComponent with HasGameRef<HereAgain> {
  Seed({position, size}) : super(position: position, size: size);
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad

    animation =
        _effectAnimation("Items/Fruits/seed", 3, true, Vector2(21, 17), 0.2);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update

    _handlePlayerSeedCollision();

    super.update(dt);
  }

  SpriteAnimation _effectAnimation(
      String state, int amt, bool loop, Vector2 size, double stepTime) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('$state.png'),
        SpriteAnimationData.sequenced(
            amount: amt, stepTime: stepTime, textureSize: size, loop: loop));
  }

  void _handlePlayerSeedCollision() async {
    if (_checkPlayerSeedCollision() && !gameRef.seedCollected) {
      if (gameRef.isSfx) {
        FlameAudio.play('pickupWaterDrop.wav');
      }
      animation = _effectAnimation(
          'Items/Fruits/Collected', 6, false, Vector2(32, 32), 0.08);

      gameRef.seedCollected = true;
      await Future.delayed(const Duration(milliseconds: 600));
      removeFromParent();
      gameRef.pauseEngine();
      gameRef.overlays.add(WonMenu.id);
    }
  }

  bool _checkPlayerSeedCollision() {
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
