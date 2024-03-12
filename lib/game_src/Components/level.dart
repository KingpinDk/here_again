import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:here_again/game_src/Components/door.dart';
import 'package:here_again/game_src/Components/fire.dart';
import 'package:here_again/game_src/Components/plant.dart';
import 'package:here_again/game_src/Components/saw.dart';
import 'package:here_again/game_src/Components/seed.dart';
import 'package:here_again/game_src/Components/water_drop.dart';
import 'package:here_again/game_src/Components/water_tap.dart';
import 'package:here_again/game_src/game.dart';

import 'box.dart';
import 'box_stop.dart';
import 'collision_block.dart';
import 'gate.dart';
import 'key.dart';
import 'land.dart';
import 'light.dart';
import 'player.dart';

class Level extends World with HasGameRef<HereAgain> {
  final String levelName;
  Player player;
  Level({required this.levelName, required this.player});
  late TiledComponent level;
  late Gate gate =
      Gate(isPresent: false, position: Vector2.all(0), size: Vector2.all(0));
  late Door door =
      Door(isPresent: false, position: Vector2.all(0), size: Vector2.all(0));
  late Light light =
      Light(position: Vector2.all(0), size: Vector2.all(0), isPresent: false);
  late BoxStop boxStop = BoxStop(position: Vector2.all(0));
  List<CollisionBlocks> collisionBlocks = [];
  List<Saw> saws = [];
  List<Box> boxes = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(levelName, Vector2.all(16));
    add(level);

    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if (spawnPointsLayer != null) {
      _addSpawnPoints(spawnPointsLayer);
    }
    player.saws = saws;

    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer != null) {
      _addCollisionBlocks(collisionsLayer);
    }
    player.collisionBlocks = collisionBlocks;
    if (gate.isPresent) {
      gate.boxes = boxes;
      gate.boxStop = boxStop;
    }
    if (door.isPresent) {
      door.boxes = boxes;
    }
    if (light.isPresent) {
      light.boxes = boxes;
      light.boxStop = boxStop;
    }
    return super.onLoad();
  }

  void _addCollisionBlocks(collisionsLayer) {
    for (final collision in collisionsLayer.objects) {
      final block = CollisionBlocks(
        position: Vector2(collision.x, collision.y),
        size: Vector2(collision.width, collision.height),
      );
      collisionBlocks.add(block);
      add(block);
    }
  }

  void _addSpawnPoints(ObjectGroup spawnPointsLayer) {
    for (final sp in spawnPointsLayer.objects) {
      switch (sp.class_) {
        case 'Player':
          player.position = Vector2(sp.x, sp.y);
          add(player);
          break;
        case 'Saw':
          final isVertical = sp.properties.getValue("isVertical");
          final offNeg = sp.properties.getValue("offNeg");
          final offPos = sp.properties.getValue("offPos");

          final saw = Saw(
              isVertical: isVertical,
              offNeg: offNeg,
              offPos: offPos,
              position: Vector2(sp.x, sp.y),
              size: Vector2(sp.height, sp.width));
          saws.add(saw);
          add(saw);
          break;
        case 'Box':
          final hasKey = sp.properties.getValue("hasKey");
          final box = Box(
              hasKey: hasKey,
              player: player,
              position: Vector2(sp.x, sp.y),
              size: Vector2(sp.width, sp.height),
              saws: saws);
          boxes.add(box);
          add(box);
          break;
        case 'Gate':
          gate = Gate(
              isPresent: true,
              position: Vector2(sp.x, sp.y),
              size: Vector2(sp.width, sp.height));
          add(gate);
          break;
        case 'BoxStop':
          boxStop = BoxStop(
            position: Vector2(sp.x, sp.y),
          );
          break;
        case 'Fire':
          final fire = Fire(
            position: Vector2(sp.x, sp.y),
            size: Vector2.all(96),
          );
          add(fire);
          break;
        case 'WaterTap':
          final waterTap = WaterTap(
              isPresent: true,
              position: Vector2(sp.x, sp.y),
              size: Vector2(sp.width, sp.height));
          add(waterTap);
          break;
        case 'Light':
          light = Light(
              size: Vector2(sp.width, sp.height),
              position: Vector2(sp.x, sp.y),
              isPresent: true);
          gameRef.light = light;
          add(light);
          break;
        case 'Door':
          door = Door(
            isPresent: true,
            size: Vector2(sp.width, sp.height),
            position: Vector2(sp.x, sp.y),
          );
          add(door);
        case 'Seed':
          final seed = Seed(
            size: Vector2(21, 17),
            position: Vector2(sp.x, sp.y),
          );
          add(seed);
        case 'key':
          final isVisible = sp.properties.getValue("isVisible");
          final key = Key(
            isVisible: isVisible,
            size: Vector2(16, 9),
            position: Vector2(sp.x, sp.y),
          );
          add(key);
        case 'land':
          final land = Land(
            position: Vector2(sp.x, sp.y),
            size: Vector2(sp.width, sp.height),
          );
          add(land);
        case 'drop':
          final drop = WaterDrop(
            position: Vector2(sp.x, sp.y),
          );
          add(drop);
        case 'plant':
          final plant = Plant(
              position: Vector2(sp.x, sp.y),
              size: Vector2(sp.width, sp.height));
          add(plant);
        default:
          break;
      }
    }
  }
}
