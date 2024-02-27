import 'dart:io';

import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:here_again/game_src/Components/player.dart';
import 'package:here_again/game_src/game.dart';

class LevelsScreen extends StatelessWidget {
  final int enabled = 7;

  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/Background/Background.png"),
            fit: BoxFit.fill,
          )),
        ),
        LevelGrid(context),
        Positioned(
            top: 10,
            right: 50,
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xFF9badb7),
                  border: Border.all(width: 5, color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(300))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/Menu/Buttons/water_drop.png",
                      width: 40,
                      height: 40,
                    ),
                    Text(
                      " 64",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Edo",
                          backgroundColor: Color(0xFF9badb7),
                          color: Color(0xFF211f30)),
                    ),
                  ],
                ),
              ),
            )),
      ],
    ));
  }

  Widget LevelGrid(context) {
    final List<int> levels = List.generate(21, (index) => index + 1);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(30),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemCount: 21,
      itemBuilder: (context, index) {
        final level = levels[index];
        return Container(
          margin: EdgeInsets.all(30),
          child: ElevatedButton(
            onPressed: () {
              if (enabled >= level) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GameWidget(
                        game: HereAgain(
                            player: Player(character: "Paari"),
                            height: height,
                            width: width,
                            level: level,
                            character: 'Paari',
                            isMobile: (!kIsWeb) &&
                                (Platform.isAndroid || Platform.isIOS),
                            isPc: (kIsWeb) ||
                                (Platform.isAndroid || Platform.isIOS)))));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Center(
                        child: Text(
                      "Complete the Level ${level - 1} to unlock",
                      style: TextStyle(
                          fontFamily: "Edo", fontSize: 20, color: Colors.red),
                    )),
                    backgroundColor: Colors.transparent));
              }
            },
            child: (enabled >= level)
                ? Image.asset(
                    "assets/images/Menu/Levels/$level.png",
                    height: 50,
                    width: 50,
                  )
                : Image.asset(
                    "assets/images/Menu/Levels/locked.png",
                    height: 50,
                    width: 50,
                  ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white38,
              shadowColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(300),
              ),
            ),
          ),
        );
      },
    );
  }
}
