import 'dart:io';

import 'package:here_again/game_src/game.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Levels extends StatelessWidget {
  Levels({super.key});




  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Center(
        child: IconButton(onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => GameWidget(game: HereAgain(character: 'Paari', isMobile: (!kIsWeb)&&(Platform.isAndroid || Platform.isIOS), isPc: (kIsWeb) || (Platform.isAndroid || Platform.isIOS)))
              ));
          },
          icon: Image.asset("assets/images/Menu/Buttons/Play.png", width: 60, height: 60,), )
      ),
    );
  }
}
