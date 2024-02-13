import 'dart:async';
import 'package:here_again/game_src/Components/saw.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'box.dart';
import 'collision_block.dart';
import 'player.dart';

class Level extends World{
  final String levelName;
  Player player;
  Level({required this.levelName, required this.player});
  late TiledComponent level;
  List<CollisionBlocks> collisionBlocks = [];


  @override
  FutureOr<void> onLoad() async{

    level = await TiledComponent.load(levelName, Vector2.all(16));
    add(level);

    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if(spawnPointsLayer != null){
      for(final sp in spawnPointsLayer.objects){
        switch(sp.class_){
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
                size: Vector2(sp.height,sp.width)
            );
            add(saw);
            break;
          case 'Box':
            final box = Box(
              player: player,
              position: Vector2(sp.x, sp.y),
              size: Vector2(sp.height, sp.width)
            );
            add(box);
            break;
          default:
            break;
        }
      }
    }

    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if(collisionsLayer != null){
      _addCollisionBlocks(collisionsLayer);
    }
    player.collisionBlocks = collisionBlocks;

    return super.onLoad();
  }

  void _addCollisionBlocks(collisionsLayer) {
    for(final collision in collisionsLayer.objects){
      final block = CollisionBlocks(
        position: Vector2(collision.x, collision.y),
        size: Vector2(collision.width, collision.height),
      );
      collisionBlocks.add(block);
      add(block);
    }
  }

}