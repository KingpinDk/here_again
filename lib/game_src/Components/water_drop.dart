import 'dart:async';

import 'package:flame/components.dart';
import 'package:here_again/game_src/game.dart';

class WaterDrop extends SpriteAnimationComponent with HasGameRef<HereAgain> {
  WaterDrop({position}) : super(position: position);

  bool _collected = false;
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    final waterAnimation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Fruits/water_drops.png'),
        SpriteAnimationData.sequenced(
            amount: 4,
            stepTime: 0.1,
            textureSize: Vector2(16, 25),
            loop: true));
    animation = waterAnimation;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    handlePlayerDropCollision();
    super.update(dt);
  }

  void handlePlayerDropCollision() {
    if (checkPlayerDropCollision()) {
      if (!_collected) {
        animation = SpriteAnimation.fromFrameData(
            game.images.fromCache('Items/Fruits/Collected.png'),
            SpriteAnimationData.sequenced(
                amount: 6,
                stepTime: 0.1,
                textureSize: Vector2(32, 32),
                loop: false));
        _collected = true;
        animationTicker?.onComplete = () {
          removeFromParent();
          gameRef.itemsCollected += 1;
          gameRef.itemStr = "Water Drops ";
        };
      }
    }
  }

  bool checkPlayerDropCollision() {
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
