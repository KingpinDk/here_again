import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:here_again/game_src/Components/items_collected.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Components/game_bar.dart';
import 'Components/level.dart';
import 'Components/light.dart';
import 'Components/player.dart';

class HereAgain extends FlameGame
    with HasKeyboardHandlerComponents, TapCallbacks, DragCallbacks {
  late final CameraComponent cam;
  double height;
  double width;
  String character;
  bool isMobile;
  bool isPc;
  bool isJoy;
  Player player;
  int level;
  bool isMusic;
  bool isSfx;
  SharedPreferences prefs;

  HereAgain(
      {required this.player,
      required this.character,
      required this.level,
      required this.isMobile,
      required this.isPc,
      this.isMusic = false,
      this.isSfx = false,
      this.isJoy = false,
      required this.height,
      required this.width,
      required this.prefs});

  bool isMarked = false;
  bool isFast = false;

  bool keyCollected = false;
  bool seedCollected = false;
  int dropCollected = 0;

  late JoystickComponent joystick;
  late SpriteComponent mask;
  late HudButtonComponent controlBtn;
  late ToggleButtonComponent toggleButtonComponent;
  late Vector2 screenSize;
  List<String> hints = [
    "Use Hand On Wall Rule",
    "press the focus\nmarker with the box",
    "Tricky Box Movement",
    "Focus Marker is invisible!!",
    "place the box on\ntriangle button",
    "press the triangle button",
    "open pause Menu",
    "use key to open the gate",
    "seed is invisible",
    "press the door",
    "key is invisible",
    "think inside the box",
    "Enter Dark void",
    "fair & simple",
    "Think Outside the map",
  ];
  List<String> missions = [
    "Fire Produces CO2\nFind and Put out\nthe fire before\nO2 runs out!!",
    "Put out the\nfire before\nO2 runs out!!\nBe aware of Blades",
    "Someone left the\nwater taps open\nclose them before\nwater runs out",
    "close the water\ntaps Focus marker\nis hidden ",
    "Electric light is kept\non for no reason\nuse triangle button to turn\nit off before power\nruns out!!",
    "Electric light is kept\non for no reason\nuse triangle button to turn\nit off before power\nruns out!!",
    "Electric light is kept\non for no reason\nuse triangle button to turn\nit off before power\nruns out!!",
    "You need seeds\nfor planting\nfind them",
    "You need seeds\nfor planting\nfind them",
    "You need seeds\nfor planting\nfind them",
    "find the place\nfor planting\nthe seeds",
    "find the place\nfor planting\nthe seeds",
    "find the place\nfor planting\nthe seeds",
    "Collect 20 water\ndrops and water\nthe plants",
    "Collect 21 water\ndrops and water\nthe plants",
  ];
  bool taskComplete = false;
  List<String> tasks = [
    "Put Out Fire",
    "Put Out Fire",
    "Turn Off the tap",
    "Turn Off the tap",
    "",
    "",
    "",
    "",
    "",
    "",
    "Plant the Seed",
    "Plant the Seeds",
    "Plant the Seeds",
    "Water the plants",
    "Water the plants",
    "Water the plants",
  ];
  late GameBar _gameBar;
  late Light light;
  late String gameSnackBar = "";
  late int itemsCollected = 0;
  late String itemStr = "Seeds";

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
    cam.follow(player);
    super.update(dt);
  }

  @override
  FutureOr<void> onLoad() async {
    await images.loadAll([
      'Items/Boxes/Box1/idle.png',
      'Items/Boxes/Box1/box_break.png',
      'Items/Boxes/Box1/box_idle.png',
      'Items/Fruits/water_drops.png',
      'Items/Fruits/Collected.png',
      'Items/Fruits/seed.png',
      'Items/Key/key.png',
      'Doors/door_closed.png',
      'Doors/door_closing.png',
      'Doors/door_opened.png',
      'Doors/door_opening.png',
      'Tasks/light_off.png',
      'Tasks/light_on.png',
      'Tasks/tap_opened.png',
      'Tasks/tap_closed.png',
      'Tasks/fire_extinguished.png',
      'Tasks/plant_grow.png',
      'Tasks/plant_still.png',
      'Tasks/plant_water_grow.png',
      'Tasks/fire_smoke.png',
      'Gates/gate_close.png',
      'Gates/gate_closed.png',
      'Gates/gate_open.png',
      'Gates/gate_opened.png',
      'Main Characters/disappear.png',
      'Main Characters/reappear.png',
      'Main Characters/Paari/idle_down.png',
      'Main Characters/Paari/death.png',
      'Main Characters/Paari/walk_down.png',
      'Main Characters/Paari/walk_up.png',
      'Main Characters/Paari/walk_right.png',
      'Main Characters/Paari/walk_left.png',
      'Main Characters/Greta/idle_down.png',
      'Main Characters/Greta/death.png',
      'Main Characters/Greta/walk_down.png',
      'Main Characters/Greta/walk_up.png',
      'Main Characters/Greta/walk_right.png',
      'Main Characters/Greta/walk_left.png',
      'Traps/Saw/On (38x38).png',
      'blindMask.png',
    ]);

    if (level == 8 || level == 9 || level == 10) {
      itemStr = "Seeds";
      add(ItemsCollected(itemStr, itemsCollected.toString()));
    } else if (level == 11) {
      itemStr = "Keys";
      add(ItemsCollected(itemStr, itemsCollected.toString()));
    } else if (level == 14 || level == 15) {
      itemStr = "Water Drops";
      add(ItemsCollected(itemsCollected.toString(), itemStr));
    }

    if (level >= 1 && level <= 7) {
      _gameBar = GameBar(x: 150, y: 21);
      add(_gameBar);
      addOverlayIcon(level);
    }
    mask = SpriteComponent.fromImage(Flame.images.fromCache('blindMask.png'),
        size: Vector2(1280, 720), priority: 10000000000);

    final world = Level(levelName: "level$level.tmx", player: player);
    cam = CameraComponent.withFixedResolution(
        world: world, width: 328, height: 186);
    cam.viewfinder.anchor = Anchor.center;
    addAll([cam, world]);

    mask.position = player.position;
    world.add(mask);

    cam.follow(player);

    if (isMobile) {
      if (isJoy) {
        addJoyStick();
      } else {
        addDirController();
      }
      addToggleButton();
    }
    if (isMusic) FlameAudio.bgm.play("21-Dungeon.wav", volume: 0.1);
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
            if (isSfx) FlameAudio.play("powerup_paari.wav");
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

  void addOverlayIcon(int level) async {
    final waterDrop = await Sprite.load('Controls/h2o.png');
    final electricPower = await Sprite.load('Controls/ep.png');
    final oxygen = await Sprite.load('Controls/o2.png');
    final SpriteComponent overlayIcon;
    if (level == 1 || level == 2) {
      overlayIcon = SpriteComponent(
          sprite: oxygen,
          size: Vector2(32, 32),
          position: Vector2(130, 21),
          priority: 456782345678678);
      add(overlayIcon);
    } else if (level == 3 || level == 4) {
      overlayIcon = SpriteComponent(
          sprite: waterDrop,
          size: Vector2(32, 32),
          position: Vector2(130, 21),
          priority: 456782345678678);
      add(overlayIcon);
    } else if (level == 5 || level == 6 || level == 7) {
      overlayIcon = SpriteComponent(
          sprite: electricPower,
          position: Vector2(120, 21),
          priority: 456782345678678);
      add(overlayIcon);
    }
  }

  // void addMusic() async {
  //   bool isOn = true;
  //   final musicOn = await Sprite.load('Controls/music_on.png');
  //   final musicOff = await Sprite.load('Controls/music_off.png');
  //
  //   final musicToggle = ToggleButtonComponent(
  //     priority: 4567890987654,
  //     size: Vector2.all(32),
  //     defaultSkin: SpriteComponent(sprite: musicOn),
  //     defaultSelectedSkin: SpriteComponent(sprite: musicOff),
  //     position: Vector2(21, 21),
  //   );
  //   add(musicToggle);
  // }
}
