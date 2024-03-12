import 'dart:async';

import 'package:flame/components.dart';
import 'package:here_again/game_src/game.dart';

import '../../overlays/task_button.dart';

enum WaterTapState { opened, closed }

class WaterTap extends SpriteAnimationGroupComponent
    with HasGameRef<HereAgain> {
  late final SpriteAnimation openedAnimation;
  late final SpriteAnimation closedAnimation;
  final double stepTime = 0.10;
  bool isPresent;

  WaterTap({required this.isPresent, position, size})
      : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() {
    priority = 0;
    // TODO: implement onLoad
    _loadWaterAnimation();
    return super.onLoad();
  }

  void _loadWaterAnimation() {
    openedAnimation = _effectAnimation('tap_opened', 4);
    closedAnimation = _effectAnimation('tap_closed', 1);

    animations = {
      WaterTapState.opened: openedAnimation,
      WaterTapState.closed: closedAnimation
    };
    current = WaterTapState.opened;
  }

  @override
  void update(double dt) {
    // TODO: implement update
    _handlePlayerTapCollision();
    turnOffTap();
    super.update(dt);
  }

  SpriteAnimation _effectAnimation(String state, int amt) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Tasks/$state.png'),
        SpriteAnimationData.sequenced(
            amount: amt, stepTime: 0.1, textureSize: Vector2(16, 32)));
  }

  void _handlePlayerTapCollision() {
    if (checkPlayerTapCollision()) {
      print("player collided with tap");
      gameRef.overlays.add(TaskButton.id);
    } else {
      if (gameRef.overlays.activeOverlays.contains(TaskButton.id)) {
        gameRef.overlays.remove(TaskButton.id);
      }
    }
  }

  bool checkPlayerTapCollision() {
    final player = gameRef.player;

    final playerHitbox = player.playerHitBox;

    final playerX = player.position.x + playerHitbox.offsetX;
    final playerY = player.position.y + playerHitbox.offsetY;
    final playerHeight = playerHitbox.height;
    final playerWidth = playerHitbox.width;

    final tapHeight = height + 32;
    final tapWidth = width + 32;

    final tapX = position.x - 16;
    final tapY = position.y - 16;

    return ((playerY < tapY + tapHeight) &&
        (playerHeight + playerY > tapY) &&
        (playerX < tapX + tapWidth) &&
        (playerWidth + playerX > tapX));
  }

  void turnOffTap() {
    if (gameRef.taskComplete == true) {
      current = SpriteAnimation.fromFrameData(
          game.images.fromCache("Tasks/tap_closed.png"),
          SpriteAnimationData.sequenced(
              amount: 1, stepTime: stepTime, textureSize: Vector2(16, 32)));
    }
  }
}
