import 'dart:async';
import 'package:here_again/game_src/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'collision_block.dart';


enum PlayerState {
  idleDown,  walkRight, walkLeft, walkUp, walkDown
}

class Player extends SpriteAnimationGroupComponent with HasGameRef<HereAgain>, KeyboardHandler{

  String character;
  Player({this.character = 'Malala', position}):super(position: position);


  late final SpriteAnimation idleDownAnimation;

  late final SpriteAnimation walkRightAnimation;
  late final SpriteAnimation walkLeftAnimation;
  late final SpriteAnimation walkUpAnimation;
  late final SpriteAnimation walkDownAnimation;
  final double stepTime = 0.10;

  List<CollisionBlocks> collisionBlocks = [];

  double horizontalMovement = 0;
  double verticalMovement = 0;
  double moveSpeed = 225;
  Vector2 velocity = Vector2.zero();

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    verticalMovement = 0;

    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);
    final isUpKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final isDownKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown);


    if(!((isLeftKeyPressed && isUpKeyPressed) || (isLeftKeyPressed && isDownKeyPressed) ||(isRightKeyPressed && isUpKeyPressed) || (isRightKeyPressed && isDownKeyPressed)))
    {
      //right and left
      horizontalMovement += isLeftKeyPressed? -1 : 0;
      horizontalMovement += isRightKeyPressed? 1 : 0;

      //up and down
      verticalMovement += isDownKeyPressed? 1 : 0;
      verticalMovement += isUpKeyPressed? -1 : 0;
    }


    return super.onKeyEvent(event, keysPressed);
  }


  @override
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerMovement(dt);
    _handleCollisions();
    super.update(dt);
  }

  @override
  FutureOr<void> onLoad() {

    _loadAllAnimation();

    return super.onLoad();
  }



  Future<void> _loadAllAnimation() async {
    idleDownAnimation = _spriteAnimation("idle_down", 6);

    walkRightAnimation = _spriteAnimation("walk_right", 6);
    walkLeftAnimation = _spriteAnimation("walk_left", 6);
    walkDownAnimation = _spriteAnimation("walk_down", 6);
    walkUpAnimation = _spriteAnimation("walk_up", 6);


    animations = {
      PlayerState.idleDown : idleDownAnimation,

      PlayerState.walkUp: walkUpAnimation,
      PlayerState.walkDown: walkDownAnimation,
      PlayerState.walkRight: walkRightAnimation,
      PlayerState.walkLeft: walkLeftAnimation,

    };
    current = PlayerState.idleDown;
  }

  SpriteAnimation _spriteAnimation(String state, int amt){
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/$character/$state.png'),
        SpriteAnimationData.sequenced(amount: amt, stepTime: stepTime, textureSize: Vector2(16,24)));
  }

  void _updatePlayerMovement(double dt) {
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;

    velocity.y = verticalMovement * moveSpeed;
    position.y += velocity.y * dt;
  }


  void _updatePlayerState() {
    if(velocity.x > 0){
      current = PlayerState.walkRight;
    }
    else if(velocity.x < 0){
      current = PlayerState.walkLeft;
    }
    else if(velocity.y < 0){
      current = PlayerState.walkUp;
    }
    else if(velocity.y > 0){
      current = PlayerState.walkDown;
    }
    else{
      current = PlayerState.idleDown;
    }

  }

  void _handleCollisions() {
    for(final block in collisionBlocks){
      if(_checkCollision(block)){

          if(velocity.x > 0){
            //right
            velocity.x = 0;
            position.x = block.x - width;
          }
          else if(velocity.x < 0){
            //left
            velocity.x = 0;
            position.x = block.x + block.width;
          }
          else if(velocity.y < 0){
            //up
            velocity.y = 0;
            position.y = block.y + block.height;
          }
          else if(velocity.y > 0){
            //down
            velocity.y = 0;
            position.y = block.y - height;
          }
      }
    }
  }


  bool _checkCollision(CollisionBlocks block){
    return ((position.y < block.y + block.height) &&
            (height + position.y > block.y) &&
            (position.x < block.x + block.width) &&
            (width + position.x > block.x));
  }



}

