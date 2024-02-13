import 'dart:async';
import 'dart:ui';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/cupertino.dart';
import 'Components/level.dart';
import 'Components/player.dart';


class HereAgain extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks{

  late final CameraComponent cam;
  late String character;
  bool isMobile;
  bool isPc;


  HereAgain({required this.character, required this.isMobile, required this.isPc});

  Player player = Player(character: "Paari");

  late JoystickComponent joystick;
  late SpriteComponent mask;


  @override
  Color backgroundColor() => const Color(0xFF000000);


  @override
  void update(double dt) {
    if(isMobile) {
      updateJoystick();
    }
    mask.position = player.position - Vector2(632,348);
    super.update(dt);
  }
  @override
  FutureOr<void> onLoad()  async {
    //debugMode = true;
    await images.loadAll([
      'Items/Boxes/Box1/idle_perfect.png',

      'Main Characters/Paari/idle_down.png',


      'Main Characters/Paari/walk_down.png',
      'Main Characters/Paari/walk_up.png',
      'Main Characters/Paari/walk_right.png',
      'Main Characters/Paari/walk_left.png',

      'Main Characters/Malala/idle_down.png',

      'Main Characters/Malala/walk_down.png',
      'Main Characters/Malala/walk_up.png',
      'Main Characters/Malala/walk_right.png',
      'Main Characters/Malala/walk_left.png',
      'Traps/Saw/On (38x38).png',

      'blindMask.png',
    ]);
    mask = SpriteComponent.fromImage(
        Flame.images.fromCache('blindMask.png'),
        size: Vector2(1280, 720),
        priority: 1000000000000000000
    );


    final world = Level(levelName: "level01.tmx", player: player);
    cam = CameraComponent.withFixedResolution(world: world, width: 328, height: 186);
    cam.viewfinder.anchor = Anchor.center;
    addAll([cam, world]);

    mask.position = player.position;
    world.add(mask);


    cam.follow(player);

    if(isMobile) {
      addJoyStick();
    }
    return super.onLoad();
  }

  void addJoyStick(){
    joystick = JoystickComponent(
      priority: 45678234567,
      knob: CircleComponent(
          radius: 20,
          paint: BasicPalette.darkGray.paint()
      ),
      background: CircleComponent(
          radius: 45,
          paint: BasicPalette.gray.withAlpha(100).paint()
      ),
      margin: const EdgeInsets.only(bottom: 32, left: 32),
    );
    add(joystick);
  }

  void updateJoystick() async {
    switch(joystick.direction){

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


}