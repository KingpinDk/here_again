import 'dart:async';

import 'package:here_again/game_src/Components/player.dart';
import 'package:here_again/game_src/game.dart';
import 'package:flame/components.dart';
import 'collision_block.dart';

class Box extends SpriteAnimationComponent with HasGameRef<HereAgain>{

  Player player;
  Box({position, size, required this.player}):super(position:  position, size: size);

  double horizontalMovement = 0;
  double verticalMovement = 0;
  double moveSpeed = 65;
  Vector2 velocity = Vector2.zero();


  @override
  void update(double dt) {
    _updateBoxMovement(dt);
    _handleBoxPlayerInteraction(dt);
    super.update(dt);
  }
  @override
  FutureOr<void> onLoad() {

    animation = SpriteAnimation.fromFrameData(game.images.fromCache("Items/Boxes/Box1/idle_perfect.png"),
      SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 0.01,
          textureSize: Vector2.all(20))
    );

    return super.onLoad();
  }

  void _handleBoxPlayerInteraction(double dt) {

      for(final block in player.collisionBlocks){

        //checks for Box Block Collision
        if(!_checkBlockCollision(block)){

          if(_checkBoxPlayerCollision(player)){
            _handleBoxPlayerCollision(dt);
          }
          else{
            horizontalMovement = 0;
            verticalMovement = 0;
          }

        }
        else{
          _handleBoxBlockCollision(block);
        }

      }
  }

  bool _checkBoxPlayerCollision(Player player) {
    return ((player.position.y < position.y + height) &&
        (player.height + player.position.y > position.y) &&
        (player.position.x < position.x + width) &&
        (player.width + player.position.x > position.x));
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
    if(player.velocity.x > 0){
      //right
      horizontalMovement += dt;
      position.x = player.position.x + player.width;
    }
    else if(player.velocity.x < 0){
      //left
      horizontalMovement -= dt;
      position.x = player.position.x - width;
    }
    else if(player.velocity.y < 0){
      //up
      verticalMovement -= dt;
      position.y = player.position.y - height;
    }
    else if(player.velocity.y > 0){
      //down
      verticalMovement += dt;
      position.y = player.position.y + player.height;
    }
    else{
      //idle
      horizontalMovement += 0;
      verticalMovement += 0;
    }
  }

  void _handleBoxBlockCollision(block) {
    horizontalMovement = 0;
    verticalMovement = 0;

    if(player.velocity.x > 0){
      // print("right");
      player.velocity.x = 0;
      position.x = block.x - width;
      player.position.x = position.x - player.width;
    }
    else if(player.velocity.x < 0){
      // print("left");
      player.velocity.x = 0;
      position.x = block.x + block.width;
      player.position.x = position.x + width;
    }
    else if(player.velocity.y < 0){
      // print("up");
      player.velocity.y = 0;
      position.y = block.y + block.height;
      player.position.y = position.y + height;
    }
    else if(player.velocity.y > 0){
      // print("down");
      player.velocity.y = 0;
      position.y = block.y - height;
      player.position.y = position.y - player.height;

    }
  }

}