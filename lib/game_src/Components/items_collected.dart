import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:here_again/game_src/game.dart';

class ItemsCollected extends TextComponent with HasGameRef<HereAgain> {
  late String itemStr;
  late String itemsCollected;
  ItemsCollected(this.itemsCollected, this.itemStr);
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    text = "${itemStr} ~ ${itemsCollected}";
    position = Vector2(gameRef.width / 2, 21);
    priority = 10000000001;
    textRenderer = TextPaint(
        style: TextStyle(color: Colors.red, fontFamily: "Edo", fontSize: 30));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    itemStr = gameRef.itemStr;
    itemsCollected = gameRef.itemsCollected.toString();
    text = "${itemStr} ~ ${itemsCollected}";
    super.update(dt);
  }
}
