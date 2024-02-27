import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Components/level.dart';
import 'Components/player.dart';

class HereAgain extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, TapCallbacks {
  late final CameraComponent cam;
  double height;
  double width;
  String character;
  bool isMobile;
  bool isPc;
  bool isJoy;
  Player player;
  int level;

  HereAgain(
      {required this.player,
      required this.character,
      required this.level,
      required this.isMobile,
      required this.isPc,
      this.isJoy = false,
      required this.height,
      required this.width});

  bool isMarked = false;
  bool isFast = false;
  late JoystickComponent joystick;
  late SpriteComponent mask;
  late HudButtonComponent controlBtn;
  late ToggleButtonComponent toggleButtonComponent;
  late Vector2 screenSize;

  @override
  Color backgroundColor() => const Color(0xFF000000);

  @override
  void update(double dt) {
    if (isMobile) {
      if (isJoy) {
        updateJoystick();
      }
    }
    mask.position = player.position - Vector2(632, 348);
    super.update(dt);
  }

  @override
  FutureOr<void> onLoad() async {
    await images.loadAll([
      'Items/Boxes/Box1/idle.png',
      'Main Characters/disappear.png',
      'Main Characters/reappear.png',
      'Main Characters/Paari/idle_down.png',
      'Main Characters/Paari/death.png',
      'Main Characters/Paari/walk_down.png',
      'Main Characters/Paari/walk_up.png',
      'Main Characters/Paari/walk_right.png',
      'Main Characters/Paari/walk_left.png',
      'Main Characters/Malala/idle_down.png',
      'Main Characters/Malala/death.png',
      'Main Characters/Malala/walk_down.png',
      'Main Characters/Malala/walk_up.png',
      'Main Characters/Malala/walk_right.png',
      'Main Characters/Malala/walk_left.png',
      'Traps/Saw/On (38x38).png',
      'blindMask.png',
    ]);
    mask = SpriteComponent.fromImage(Flame.images.fromCache('blindMask.png'),
        size: Vector2(1280, 720), priority: 1000000000000000000);

    final world = Level(levelName: "level1.tmx", player: player);
    cam = CameraComponent.withFixedResolution(
        world: world, width: 328, height: 186);
    cam.viewfinder.anchor = Anchor.center;
    addAll([cam, world]);

    mask.position = player.position;
    world.add(mask);

    cam.follow(player);
    addSettings();
    addMusic();
    if (isMobile) {
      if (isJoy) {
        addJoyStick();
      } else {
        addDirController();
      }
      addToggleButton();
    }
    return super.onLoad();
  }

  void addJoyStick() {
    joystick = JoystickComponent(
      priority: 45678234567,
      knob: CircleComponent(radius: 20, paint: BasicPalette.darkGray.paint()),
      background: CircleComponent(
          radius: 45, paint: BasicPalette.gray.withAlpha(100).paint()),
      margin: const EdgeInsets.only(bottom: 32, left: 32),
    );
    add(joystick);
  }

  void updateJoystick() async {
    switch (joystick.direction) {
      case JoystickDirection.down:
        Future.delayed(const Duration(milliseconds: 100));
        player.verticalMovement = 1;
        break;

      case JoystickDirection.up:
        Future.delayed(const Duration(milliseconds: 100));
        player.verticalMovement = -1;
        break;

      case JoystickDirection.right:
        Future.delayed(const Duration(milliseconds: 100));
        player.horizontalMovement = 1;
        break;

      case JoystickDirection.left:
        Future.delayed(const Duration(milliseconds: 100));
        player.horizontalMovement = -1;
        break;

      default:
        player.verticalMovement = 0;
        player.horizontalMovement = 0;
        break;
    }
  }

  void addToggleButton() async {
    if (player.character == "Paari") {
      final fastBtnLight = await Sprite.load('Controls/fast_grey.png');
      final fastBtnDark = await Sprite.load('Controls/fast_white.png');
      toggleButtonComponent = ToggleButtonComponent(
          position: Vector2(width - 120, height - 150),
          priority: 4567899876523,
          onPressed: () {
            if (isFast) {
              isFast = false;
              player.moveSpeed = 225;
            } else {
              isFast = true;
              player.moveSpeed = 500;
            }
          },
          defaultSelectedSkin: SpriteComponent(
            sprite: fastBtnDark,
          ),
          defaultSkin: SpriteComponent(
            sprite: fastBtnLight,
          ));
    } else {
      final teleBtnLight = await Sprite.load('Controls/teleport_grey.png');
      final teleBtnDark = await Sprite.load('Controls/teleport_white.png');

      toggleButtonComponent = ToggleButtonComponent(
        position: Vector2(width - 120, height - 150),
        priority: 4567899876523,
        onPressed: () {
          if (isMarked) {
            isMarked = false;
            player.isTelePort = true;
          } else {
            isMarked = true;
            player.markedPos = Vector2.copy(player.position);
          }
        },
        defaultSelectedSkin: SpriteComponent(
          sprite: teleBtnLight,
        ),
        defaultSkin: SpriteComponent(
          sprite: teleBtnDark,
        ),
      );
    }

    add(toggleButtonComponent);
  }

  Future<void> addDirController() async {
    final rightBtnSprite = await Sprite.load('Controls/right_white.png');
    final tapRightBtnSprite = await Sprite.load('Controls/right_grey.png');
    addButton(rightBtnSprite, tapRightBtnSprite, () {
      if (player.verticalMovement == 0) player.horizontalMovement = 1;
    }, 130, 90);

    final leftBtnSprite = await Sprite.load('Controls/left_white.png');
    final tapLeftBtnSprite = await Sprite.load('Controls/left_grey.png');
    addButton(leftBtnSprite, tapLeftBtnSprite, () {
      if (player.verticalMovement == 0) player.horizontalMovement = -1;
    }, 10, 90);

    final upBtnSprite = await Sprite.load('Controls/up_white.png');
    final tapUpBtnSprite = await Sprite.load('Controls/up_grey.png');
    addButton(upBtnSprite, tapUpBtnSprite, () {
      if (player.horizontalMovement == 0) player.verticalMovement = -1;
    }, 70, 150);

    final downBtnSprite = await Sprite.load('Controls/down_white.png');
    final tapDownBtnSprite = await Sprite.load('Controls/down_grey.png');
    addButton(downBtnSprite, tapDownBtnSprite, () {
      if (player.horizontalMovement == 0) player.verticalMovement = 1;
    }, 70, 30);
  }

  void addButton(
      Sprite idle, Sprite tapped, onTap, double left, double bottom) {
    controlBtn = HudButtonComponent(
        margin: EdgeInsets.only(left: left, bottom: bottom),
        priority: 4556786789,
        button: SpriteComponent(size: Vector2.all(65), sprite: idle),
        buttonDown: SpriteComponent(
          sprite: tapped,
          size: Vector2.all(70),
        ),
        onPressed: onTap,
        onReleased: () {
          player.horizontalMovement = 0;
          player.verticalMovement = 0;
        });
    add(controlBtn);
  }

  void addSettings() async {
    final settings = await Sprite.load('Controls/settings_white.png');
    final settingsOnTap = await Sprite.load('Controls/settings_grey.png');

    final settingsHud = HudButtonComponent(
      priority: 456782345678678,
      button: SpriteComponent(sprite: settings, size: Vector2.all(32)),
      buttonDown: SpriteComponent(sprite: settingsOnTap, size: Vector2.all(34)),
      margin: const EdgeInsets.only(top: 21, right: 21),
    );
    add(settingsHud);
  }

  void addMusic() async {
    bool isOn = true;
    final musicOn = await Sprite.load('Controls/music_on.png');
    final musicOff = await Sprite.load('Controls/music_off.png');

    final musicToggle = ToggleButtonComponent(
      priority: 4567890987654,
      size: Vector2.all(32),
      defaultSkin: SpriteComponent(sprite: musicOn),
      defaultSelectedSkin: SpriteComponent(sprite: musicOff),
      position: Vector2(21, 21),
    );
    add(musicToggle);
  }
}
