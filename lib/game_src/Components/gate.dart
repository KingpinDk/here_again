import 'dart:async';

import 'package:flame/components.dart';

import '../game.dart';
import 'box.dart';
import 'box_stop.dart';

enum GateState { closed, opened, opening, closing }

class Gate extends SpriteAnimationGroupComponent with HasGameRef<HereAgain> {
  late final SpriteAnimation openedAnimation;
  late final SpriteAnimation closedAnimation;
  late final SpriteAnimation openingAnimation;
  late final SpriteAnimation closingAnimation;
  final double stepTime = 0.10;
  late final BoxStop boxStop;
  bool isPresent;
  List<Box> boxes = [];
  bool gateOpened = false;

  Gate({required this.isPresent, position, size})
      : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    priority = 1000;
    loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    _handleGateBoxCollision();
    _handleGatePlayerCollision();
    checkBoxPlaced();
    super.update(dt);
  }

  void loadAllAnimations() {
    openedAnimation = _effectAnimation("gate_opened", 1);
    closedAnimation = _effectAnimation("gate_closed", 1);

    openingAnimation = _effectAnimation("gate_open", 10);
    closingAnimation = _effectAnimation("gate_close", 10);

    animations = {
      GateState.opened: openedAnimation,
      GateState.closed: closedAnimation,
      GateState.closing: closingAnimation,
      GateState.opening: openingAnimation
    };
    if (gameRef.level != 15) current = GateState.closed;
  }

  SpriteAnimation _effectAnimation(String state, int amt) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Gates/$state.png'),
        SpriteAnimationData.sequenced(
            amount: amt, stepTime: 0.08, textureSize: Vector2(32, 64)));
  }

  void checkBoxPlaced() async {
    for (final box in boxes) {
      if (_isOnTop(box, boxStop)) {
        gateOpened = true;
        await Future.delayed(const Duration(milliseconds: 100)).then((value) {
          if (gameRef.level != 15) current = GateState.opening;
        });
        if (gameRef.level != 15) current = GateState.opened;
      } else {
        await Future.delayed(const Duration(milliseconds: 100)).then((value) {
          if (gameRef.level != 15) current = GateState.closing;
        });
        if (gameRef.level != 15) current = GateState.closed;
      }
    }
  }

  bool _checkGatePlayerCollision() {
    final player = gameRef.player;
    final playerHitbox = player.playerHitBox;

    final playerX = player.position.x + playerHitbox.offsetX;
    final playerY = player.position.y + playerHitbox.offsetY;
    final playerHeight = playerHitbox.height;
    final playerWidth = playerHitbox.width;

    return ((playerY < position.y + height - 12) &&
        (playerHeight + playerY > position.y) &&
        (playerX < position.x + width) &&
        (playerWidth + playerX > position.x));
  }

  void _handleGatePlayerCollision() {
    final player = gameRef.player;
    if (_checkGatePlayerCollision() && !gateOpened) {
      if (player.velocity.x > 0) {
        //right
        player.velocity.x = 0;
        player.position.x = position.x -
            (player.playerHitBox.width + player.playerHitBox.offsetX);
      } else if (player.velocity.x < 0) {
        //left
        player.velocity.x = 0;
        player.position.x = position.x + width - player.playerHitBox.offsetX;
      } else if (player.velocity.y < 0) {
        //up
        player.velocity.y = 0;
        player.position.y =
            position.y + height - 12 - player.playerHitBox.offsetY;
      } else if (player.velocity.y > 0) {
        //down
        player.velocity.y = 0;
        player.position.y = position.y -
            (player.playerHitBox.height + player.playerHitBox.offsetY);
      }
    }
  }

  bool _checkGateBoxCollision(Box box) {
    return ((box.y < position.y + height) &&
        (box.height + box.y > position.y) &&
        (box.x < position.x + width) &&
        (box.width + box.x > position.x));
  }

  void _handleGateBoxCollision() {
    for (final box in boxes) {
      if (_checkGateBoxCollision(box)) {
        _handleBoxGateCollision(box);
      }
    }
  }

  void _handleBoxGateCollision(box) {
    final player = gameRef.player;
    final playerHitbox = player.playerHitBox;
    final playerHeight = playerHitbox.height;
    final playerWidth = playerHitbox.width;

    player.horizontalMovement = 0;
    player.verticalMovement = 0;

    if (player.velocity.x > 0) {
      // print("right");
      player.velocity.x = 0;
      box.position.x = position.x - box.width;
      player.position.x = box.position.x - (playerWidth + playerHitbox.offsetX);
    } else if (player.velocity.x < 0) {
      // print("left");
      player.velocity.x = 0;
      box.position.x = position.x + width;
      player.position.x = box.position.x + box.width - playerHitbox.offsetX;
    } else if (player.velocity.y < 0) {
      // print("up");
      player.velocity.y = 0;
      box.position.y = position.y + height;
      player.position.y = box.position.y + box.height - playerHitbox.offsetY;
    } else if (player.velocity.y > 0) {
      // print("down");
      player.velocity.y = 0;
      box.position.y = position.y - box.height;
      player.position.y =
          box.position.y - (playerHeight + playerHitbox.offsetY);
    }
  }

  bool _isOnTop(Box box, BoxStop boxStop) {
    double boxX1 = box.position.x;
    double boxY1 = box.position.y;

    double boxX2 = box.position.x + 16;
    double boxY2 = box.position.y;

    double boxX3 = box.position.x;
    double boxY3 = box.position.y + 16;

    double boxX4 = box.position.x + 16;
    double boxY4 = box.position.y + 16;

    double bsX1 = boxStop.x - 3;
    double bsY1 = boxStop.y - 3;

    double bsX2 = boxStop.x + 19;
    double bsY2 = boxStop.y - 3;

    double bsX3 = boxStop.x - 3;
    double bsY3 = boxStop.y + 19;

    double bsX4 = boxStop.x + 19;
    double bsY4 = boxStop.y + 19;

    return ((boxX1 > bsX1 && boxY1 > bsY1) &&
        (boxX2 < bsX2 && boxY2 > bsY2) &&
        (boxX3 > bsX3 && boxY3 < bsY3) &&
        (boxX4 < bsX4 && boxY4 < bsY4));
  }
}
