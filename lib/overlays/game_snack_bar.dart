import 'package:flutter/material.dart';

import '../game_src/game.dart';

class GameSnackBar extends StatelessWidget {
  static const String id = "gameSnackBar";
  final HereAgain gameRef;
  const GameSnackBar({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 100,
        width: 300,
        child: Card(
          color: Colors.black38,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                gameRef.gameSnackBar,
                style: TextStyle(
                    fontFamily: "Edo", fontSize: 20, color: Colors.red),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
