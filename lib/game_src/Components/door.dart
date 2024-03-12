import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:here_again/game_src/game.dart';
import 'package:here_again/overlays/game_snack_bar.dart';

import 'box.dart';

enum DoorState { closed, open, closing, opening }

class Door extends SpriteAnimationGroupComponent with HasGameRef<HereAgain> {
  late final SpriteAnimation openingAnimation;
  late final SpriteAnimation closingAnimation;
  late final SpriteAnimation openAnimation;
  late final SpriteAnimation closeAnimation;
  bool isPresent;
  List<Box> boxes = [];
  Door({position, size, required this.isPresent})
      : super(position: position, size: size);
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    priority = 1000;
    _loadDoorAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    _handlePlayerInteraction();
    _handleBoxInteraction();
    if (gameRef.level == 10) {
      addButtonDoor();
    }
    super.update(dt);
  }

  void _loadDoorAnimations() {
    closingAnimation = _effectAnimation("door_closing", 4);
    closeAnimation = _effectAnimation("door_closed", 1);
    openingAnimation = _effectAnimation("door_opening", 4);
    openAnimation = _effectAnimation("door_opened", 1);

    animations = {
      DoorState.closed: closeAnimation,
      DoorState.closing: closingAnimation,
      DoorState.opening: openingAnimation,
      DoorState.open: openAnimation
    };
    current = DoorState.closed;
  }

  SpriteAnimation _effectAnimation(String state, int amt) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Doors/$state.png'),
        SpriteAnimationData.sequenced(
            amount: amt, stepTime: 0.1, textureSize: Vector2(32, 32)));
  }

  void _handlePlayerInteraction() async {
    final player = gameRef.player;
    if (_checkPlayerCollision() && current != DoorState.open) {
      if (gameRef.keyCollected) {
        current = DoorState.opening;
        await Future.delayed(Duration(milliseconds: 400));
        current = DoorState.open;
      } else {
        if (gameRef.level != 10)
          gameRef.gameSnackBar = "needs key";
        else
          gameRef.gameSnackBar = "knock knock";
        gameRef.overlays.add(GameSnackBar.id);

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
          player.position.y = position.y + height - player.playerHitBox.offsetY;
        } else if (player.velocity.y > 0) {
          //down
          player.velocity.y = 0;
          player.position.y = position.y -
              (player.playerHitBox.height + player.playerHitBox.offsetY);
        }
      }
    } else {
      if (gameRef.overlays.activeOverlays.contains(GameSnackBar.id))
        gameRef.overlays.remove(GameSnackBar.id);
    }
  }

  bool _checkPlayerCollision() {
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

  void addButtonDoor() async {
    final door = await Sprite.load('Doors/door_button.png');
    final doorOnTap = await Sprite.load('Doors/door_button.png');

    HudButtonComponent playHud = HudButtonComponent(
        priority: -9999999991,
        button: SpriteComponent(sprite: door, size: Vector2.all(32)),
        buttonDown: SpriteComponent(sprite: doorOnTap, size: Vector2.all(32)),
        position: Vector2(0.0, 0.0),
        onPressed: () async {
          current = DoorState.opening;
          await Future.delayed(const Duration(milliseconds: 400));
          current = DoorState.open;
        });

    add(playHud);
  }

  void _handleBoxInteraction() {
    for (final box in boxes) {
      if (_checkBoxCollision(box)) {
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
          player.position.x =
              box.position.x - (playerWidth + playerHitbox.offsetX);
        } else if (player.velocity.x < 0) {
          // print("left");
          player.velocity.x = 0;
          box.position.x = position.x + width;
          player.position.x = box.position.x + box.width - playerHitbox.offsetX;
        } else if (player.velocity.y < 0) {
          // print("up");
          player.velocity.y = 0;
          box.position.y = position.y + height;
          player.position.y =
              box.position.y + box.height - playerHitbox.offsetY;
        } else if (player.velocity.y > 0) {
          // print("down");
          player.velocity.y = 0;
          box.position.y = position.y - box.height;
          player.position.y =
              box.position.y - (playerHeight + playerHitbox.offsetY);
        }
      }
    }
  }

  bool _checkBoxCollision(Box box) {
    return ((box.y < position.y + height) &&
        (box.height + box.y > position.y) &&
        (box.x < position.x + width) &&
        (box.width + box.x > position.x));
  }
}
