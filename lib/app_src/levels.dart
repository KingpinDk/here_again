import 'dart:io';

import 'package:here_again/game_src/Components/player.dart';
import 'package:here_again/game_src/game.dart';
import 'package:flame/game.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Levels extends StatelessWidget {
  Levels({super.key});




  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: IconButton(onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => GameWidget(game: HereAgain(player: Player(character: "Malala"), height: height, width: width, character: 'Paari', isMobile: (!kIsWeb)&&(Platform.isAndroid || Platform.isIOS), isPc: (kIsWeb) || (Platform.isAndroid || Platform.isIOS)))
              ));
          },
          icon: Image.asset("assets/images/Menu/Buttons/Play.png", width: 60, height: 60,), )
      ),
    );
  }
}
