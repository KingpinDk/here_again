import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:here_again/game_src/game.dart';
import 'package:here_again/overlays/lost_menu.dart';

class GameBar extends Component with HasGameRef<HereAgain> {
  final double x;
  final double y;
  final double width = 200;
  final double height = 30;
  final Paint _backgroundPaint;
  late Paint _barPaint;
  double progress;
  GameBar({
    required this.x,
    required this.y,
    double progress = 1.0,
  })  : progress = progress,
        _backgroundPaint = Paint()..color = Colors.white,
        _barPaint = Paint()..color = Colors.red;

  void setProgress(double progress) {
    progress = progress;
  }

  @override
  void render(Canvas canvas) {
    priority = 9999999999;
    if (gameRef.level == 3 || gameRef.level == 4) {
      _barPaint = Paint()..color = Colors.blueAccent;
    } else if (gameRef.level == 5 || gameRef.level == 6 || gameRef.level == 7) {
      _barPaint = Paint()..color = Colors.yellowAccent;
    }
    const Radius radius = Radius.circular(10);
    final backgroundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(x, y, width, height),
      radius, // Adjust the radius for curved edges
    );
    canvas.drawRRect(backgroundRect, _backgroundPaint);

    final foregroundRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x + 3, y + 3, (width * progress) - 6, height - 6),
        radius);
    canvas.drawRRect(foregroundRect, _barPaint);
  }

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    return super.onLoad();
  }

  @override
  void update(double dt) async {
    if (progress <= 0) {
      progress = 0;
      if (gameRef.level == 1 || gameRef.level == 2) {
        gameRef.player.isDead = true;
      } else if (gameRef.level == 3 || gameRef.level == 4) {
        LostMenu.msg = "Baka!! Every bit of\n water is Lost";
        gameRef.overlays.add(LostMenu.id);
      } else if (gameRef.level == 5 ||
          gameRef.level == 6 ||
          gameRef.level == 7) {
        LostMenu.msg =
            "No Electric Power Left\n In your terms mission\nis successfully Lost";
        gameRef.overlays.add(LostMenu.id);
      }
    } else {
      progress -= .0001;
    }
  }
}
