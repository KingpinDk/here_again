import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:here_again/game_src/Components/player_hitbox.dart';
import 'package:here_again/game_src/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'collision_block.dart';


enum PlayerState {
  idleDown,  walkRight, walkLeft, walkUp, walkDown, disAppear, reAppear, none
}

class Player extends SpriteAnimationGroupComponent with HasGameRef<HereAgain>, KeyboardHandler{

  String character;
  PlayerHitBox playerHitBox = PlayerHitBox(offsetX: 2, offsetY: 3, width: 12, height: 20);
  Player({this.character = 'Paari', position}):super(position: position);


  late final SpriteAnimation idleDownAnimation;

  late final SpriteAnimation walkRightAnimation;
  late final SpriteAnimation walkLeftAnimation;
  late final SpriteAnimation walkUpAnimation;
  late final SpriteAnimation walkDownAnimation;
  late final SpriteAnimation disAppearAnimation;
  late final SpriteAnimation reAppearAnimation;

  final double stepTime = 0.10;

  List<CollisionBlocks> collisionBlocks = [];
  
  late bool isMarked = false;
  late bool isFast = false;
  late bool isTelePort = false;
  late bool isDis = false;
  Vector2 markedPos = Vector2(0, 0);
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
    final isSpaceKeyPressed = keysPressed.contains(LogicalKeyboardKey.space);


    if(!((isLeftKeyPressed && isUpKeyPressed) || (isLeftKeyPressed && isDownKeyPressed) ||(isRightKeyPressed && isUpKeyPressed) || (isRightKeyPressed && isDownKeyPressed)))
    {
      //right and left
      horizontalMovement += isLeftKeyPressed? -1 : 0;
      horizontalMovement += isRightKeyPressed? 1 : 0;

      //up and down
      verticalMovement += isDownKeyPressed? 1 : 0;
      verticalMovement += isUpKeyPressed? -1 : 0;
    }

    if(isSpaceKeyPressed){

      if(character == 'Paari'){
        if(isFast){
          isFast = false;
          moveSpeed = 225;

        }
        else{
          isFast = true;
          moveSpeed = 500;

        }
      }
      else{
        if(isMarked){
          isMarked = false;
          isTelePort = true;
        }
        else{
          isMarked = true;
          markedPos = Vector2.copy(position);

        }
      }
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
    //debugMode = true;
    _loadAllAnimation();
    add(RectangleHitbox(position: Vector2(2, 3), size: Vector2(12,20)));
    return super.onLoad();
  }



  Future<void> _loadAllAnimation() async {
    idleDownAnimation = _spriteAnimation("idle_down", 6);

    walkRightAnimation = _spriteAnimation("walk_right", 6);
    walkLeftAnimation = _spriteAnimation("walk_left", 6);
    walkDownAnimation = _spriteAnimation("walk_down", 6);
    walkUpAnimation = _spriteAnimation("walk_up", 6);

    disAppearAnimation = _effectAnimation("disappear", 9);
    reAppearAnimation = _effectAnimation("reappear", 9);

    animations = {
      PlayerState.idleDown : idleDownAnimation,

      PlayerState.walkUp: walkUpAnimation,
      PlayerState.walkDown: walkDownAnimation,
      PlayerState.walkRight: walkRightAnimation,
      PlayerState.walkLeft: walkLeftAnimation,

      PlayerState.reAppear: reAppearAnimation,
      PlayerState.disAppear: disAppearAnimation

    };
    current = PlayerState.idleDown;
  }

  SpriteAnimation _effectAnimation(String state, int amt){
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/$state.png'),
        SpriteAnimationData.sequenced(amount: amt, stepTime: 0.15, textureSize: Vector2(16,24)));
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


  Future<void> _updatePlayerState() async {
    if(isTelePort){
      velocity.x = 0;
      velocity.y = 0;
      current = PlayerState.disAppear;
      await Future.delayed(const Duration(milliseconds: 1350),(){
      isTelePort = false;
      position = markedPos;
       isDis = true;
      });

    }
    else if(isDis){
      velocity.x = 0;
      velocity.y = 0;
      current = PlayerState.reAppear;
      await Future.delayed(const Duration(milliseconds: 1350),(){
        isDis = false;
        position = markedPos;
      });
    }
    else if(velocity.x > 0){
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
            position.x = block.x - (playerHitBox.width + playerHitBox.offsetX);
          }
          else if(velocity.x < 0){
            //left
            velocity.x = 0;
            position.x = block.x + block.width - playerHitBox.offsetX;
          }
          else if(velocity.y < 0){
            //up
            velocity.y = 0;
            position.y = block.y + block.height - playerHitBox.offsetY;
          }
          else if(velocity.y > 0){
            //down
            velocity.y = 0;
            position.y = block.y - (playerHitBox.height + playerHitBox.offsetY);
          }
      }
    }
  }


  bool _checkCollision(CollisionBlocks block){

    final playerY = position.y + playerHitBox.offsetY;
    final playerX = position.x + playerHitBox.offsetX;
    final playerWidth = playerHitBox.width;
    final playerHeight = playerHitBox.height;

    return ((playerY < block.y + block.height) &&
            (playerHeight + playerY > block.y) &&
            (playerX < block.x + block.width) &&
            (playerWidth + playerX > block.x));
  }

}

