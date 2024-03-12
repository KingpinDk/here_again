import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:here_again/game_src/Components/box.dart';
import 'package:here_again/game_src/game.dart';
import 'package:here_again/overlays/won_menu.dart';

import 'box_stop.dart';

enum LightState { lightOn, lightOff }

class Light extends SpriteAnimationGroupComponent with HasGameRef<HereAgain> {
  late BoxStop boxStop;
  bool isPresent;
  Light({position, size, required this.isPresent})
      : super(position: position, size: size);
  late final SpriteAnimation onAnimation;
  late final SpriteAnimation offAnimation;
  late final HudButtonComponent playHud;
  List<Box> boxes = [];

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    _loadLightAnimation();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update

    _handleLightPlayerInteraction();

    super.update(dt);
  }

  SpriteAnimation _effectAnimation(String state, int amt) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Tasks/$state.png'),
        SpriteAnimationData.sequenced(
          amount: amt,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
        ));
  }

  void _loadLightAnimation() {
    if (gameRef.level == 6) {
      _addPlayTap();
    }
    onAnimation = _effectAnimation('light_on', 3);
    offAnimation = _effectAnimation('light_off', 1);

    animations = {
      LightState.lightOn: onAnimation,
      LightState.lightOff: offAnimation,
    };
    current = LightState.lightOn;
  }

  void _handleLightPlayerInteraction() async {
    if (gameRef.level == 5) {
      for (final box in boxes) {
        if (_isOnTop(box, boxStop)) {
          current = LightState.lightOff;
          await Future.delayed(const Duration(milliseconds: 500));
          gameRef.pauseEngine();
          gameRef.overlays.add(WonMenu.id);
        }
      }
    }
  }

  void _addPlayTap() async {
    final play = await Sprite.load('Controls/playmarker.png');
    final playOnTap = await Sprite.load('Controls/playmarker.png');

    playHud = HudButtonComponent(
        priority: -9999999991,
        button: SpriteComponent(sprite: play, size: Vector2.all(16)),
        buttonDown: SpriteComponent(sprite: playOnTap, size: Vector2.all(16)),
        position: Vector2(-32.0, 48.0),
        onPressed: () async {
          // taskComplete = true;
          current = LightState.lightOff;
          await Future.delayed(const Duration(milliseconds: 500));
          gameRef.pauseEngine();
          gameRef.overlays.add(WonMenu.id);
        });

    add(playHud);
  }

  bool _isOnTop(Box box, BoxStop boxStop) {
    double boxX1 = box.position.x;
    double boxY1 = box.position.y;

    double boxX2 = box.position.x + 16;
    double boxY2 = box.position.y;

    double boxX3 = box.position.x;
    double boxY3 = box.position.y + 16;

    double boxX4 = box.position.x + 16;
    double boxY4 = box.position.y + 16;

    double bsX1 = boxStop.x - 3;
    double bsY1 = boxStop.y - 3;

    double bsX2 = boxStop.x + 19;
    double bsY2 = boxStop.y - 3;

    double bsX3 = boxStop.x - 3;
    double bsY3 = boxStop.y + 19;

    double bsX4 = boxStop.x + 19;
    double bsY4 = boxStop.y + 19;

    return ((boxX1 > bsX1 && boxY1 > bsY1) &&
        (boxX2 < bsX2 && boxY2 > bsY2) &&
        (boxX3 > bsX3 && boxY3 < bsY3) &&
        (boxX4 < bsX4 && boxY4 < bsY4));
  }
}
