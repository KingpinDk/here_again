import 'dart:async';

import 'package:flame/components.dart';
import 'package:here_again/game_src/Components/player.dart';
import 'package:here_again/game_src/Components/saw.dart';
import 'package:here_again/game_src/game.dart';

import 'collision_block.dart';

enum BoxState { idle, broke, key, spawn }

class Box extends SpriteAnimationGroupComponent with HasGameRef<HereAgain> {
  Player player;
  List<Saw> saws;
  bool hasKey;
  Box(
      {position,
      size,
      required this.player,
      required this.saws,
      required this.hasKey})
      : super(position: position, size: size);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation brokeAnimation;

  late final SpriteAnimation appearAnimation;
  late final SpriteAnimation keyAnimation;

  double horizontalMovement = 0;
  double verticalMovement = 0;
  double moveSpeed = 65;
  Vector2 velocity = Vector2.zero();

  @override
  void update(double dt) {
    _updateBoxMovement(dt);
    _handleBoxPlayerInteraction(dt);
    _handleBoxSawInteraction();
    super.update(dt);
  }

  @override
  FutureOr<void> onLoad() {
    priority = 900;

    _loadBoxAnimation();
    return super.onLoad();
  }

  void _loadBoxAnimation() {
    idleAnimation = _effectAnimation(
        'Items/Boxes/Box1/box_idle', 1, true, Vector2(16, 16), 0.1);
    brokeAnimation = _effectAnimation(
        'Items/Boxes/Box1/box_break', 7, false, Vector2(16, 16), 0.1);

    keyAnimation =
        _effectAnimation("Items/Key/key", 4, true, Vector2(16, 9), 0.1);
    appearAnimation = _effectAnimation(
        "Items/Fruits/Collected", 6, false, Vector2(24, 24), 0.1);

    animations = {
      BoxState.idle: idleAnimation,
      BoxState.broke: brokeAnimation,
      BoxState.key: keyAnimation,
      BoxState.spawn: appearAnimation
    };
    current = BoxState.idle;
  }

  SpriteAnimation _effectAnimation(
      String state, int amt, bool loop, Vector2 size, double stepTime) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('$state.png'),
        SpriteAnimationData.sequenced(
            amount: amt, stepTime: stepTime, textureSize: size, loop: loop));
  }

  void _handleBoxPlayerInteraction(double dt) {
    for (final block in player.collisionBlocks) {
      //checks for Box Block Collision
      if (!_checkBlockCollision(block)) {
        if (_checkBoxPlayerCollision(player)) {
          _handleBoxPlayerCollision(dt);
        } else {
          horizontalMovement = 0;
          verticalMovement = 0;
        }
      } else {
        _handleBoxBlockCollision(block);
      }
    }
  }

  bool _checkBoxPlayerCollision(Player player) {
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

  void _updateBoxMovement(double dt) {
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;

    velocity.y = verticalMovement * moveSpeed;
    position.y += velocity.y * dt;
  }

  bool _checkBlockCollision(CollisionBlocks block) {
    return ((position.y < block.y + block.height) &&
        (height + position.y > block.y) &&
        (position.x < block.x + block.width) &&
        (width + position.x > block.x));
  }

  void _handleBoxPlayerCollision(double dt) {
    final playerHitbox = player.playerHitBox;

    final playerX = player.position.x + playerHitbox.offsetX;
    final playerY = player.position.y + playerHitbox.offsetY;
    final playerHeight = playerHitbox.height;
    final playerWidth = playerHitbox.width;

    if (player.velocity.x > 0) {
      //right
      horizontalMovement += dt;
      position.x = playerX + playerWidth;
    } else if (player.velocity.x < 0) {
      //left
      horizontalMovement -= dt;
      position.x = playerX - width;
    } else if (player.velocity.y < 0) {
      //up
      verticalMovement -= dt;
      position.y = playerY - height;
    } else if (player.velocity.y > 0) {
      //down
      verticalMovement += dt;
      position.y = playerY + playerHeight;
    } else {
      //idle
      horizontalMovement += 0;
      verticalMovement += 0;
    }
  }

  void _handleBoxBlockCollision(block) {
    final playerHitbox = player.playerHitBox;
    final playerHeight = playerHitbox.height;
    final playerWidth = playerHitbox.width;

    horizontalMovement = 0;
    verticalMovement = 0;

    if (player.velocity.x > 0) {
      // print("right");
      player.velocity.x = 0;
      position.x = block.x - width;
      player.position.x = position.x - (playerWidth + playerHitbox.offsetX);
    } else if (player.velocity.x < 0) {
      // print("left");
      player.velocity.x = 0;
      position.x = block.x + block.width;
      player.position.x = position.x + width - playerHitbox.offsetX;
    } else if (player.velocity.y < 0) {
      // print("up");
      player.velocity.y = 0;
      position.y = block.y + block.height;
      player.position.y = position.y + height - playerHitbox.offsetY;
    } else if (player.velocity.y > 0) {
      // print("down");
      player.velocity.y = 0;
      position.y = block.y - height;
      player.position.y = position.y - (playerHeight + playerHitbox.offsetY);
    }
  }

  bool _checkBoxSawCollision(Saw saw) {
    return ((position.y < saw.y + saw.height) &&
        (height + position.y > saw.y) &&
        (position.x < saw.x + saw.width) &&
        (width + position.x > saw.x));
  }

  void _handleBoxSawInteraction() async {
    for (final saw in saws) {
      if (_checkBoxSawCollision(saw)) {
        current = BoxState.broke;
        await Future.delayed(Duration(milliseconds: 400));
        if (hasKey) {
          current = BoxState.spawn;
          await Future.delayed(Duration(milliseconds: 600));
          current = BoxState.key;
          await Future.delayed(Duration(milliseconds: 400));
          gameRef.keyCollected = true;
        }
        removeFromParent();
      }
    }
  }
}
