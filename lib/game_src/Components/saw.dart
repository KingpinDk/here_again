import 'dart:async';

import 'package:flame/components.dart';
import 'package:here_again/game_src/game.dart';

class Saw extends SpriteAnimationComponent with HasGameRef<HereAgain> {
  final bool isVertical;
  final double offNeg;
  final double offPos;
  Saw(
      {this.isVertical = false,
      this.offNeg = 0,
      this.offPos = 0,
      position,
      size})
      : super(position: position, size: size);

  late int moveSpeed = 80;
  static const tileSize = 16;
  double moveDirection = 1;
  double rangeNeg = 0;
  double rangePos = 0;

  @override
  FutureOr<void> onLoad() {
    priority = 1000;
    if (isVertical) {
      rangeNeg = position.y - offNeg * tileSize;
      rangePos = position.y + offPos * tileSize;
    } else {
      rangeNeg = position.x - offNeg * tileSize;
      rangePos = position.x + offPos * tileSize;
    }
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache("Traps/Saw/On (38x38).png"),
        SpriteAnimationData.sequenced(
            amount: 8, stepTime: 0.03, textureSize: Vector2.all(38)));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (isVertical) {
      _moveVertical(dt);
    } else {
      _moveHorizontal(dt);
    }
    super.update(dt);
  }

  void _moveVertical(double dt) {
    if (position.y >= rangePos) {
      moveDirection = -1;
    } else if (position.y <= rangeNeg) {
      moveDirection = 1;
    }
    position.y += moveDirection * moveSpeed * dt;
  }

  void _moveHorizontal(double dt) {
    if (position.x >= rangePos) {
      moveDirection = -1;
    } else if (position.x <= rangeNeg) {
      moveDirection = 1;
    }
    position.x += moveDirection * moveSpeed * dt;
  }
}
