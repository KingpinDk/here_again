import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:here_again/app_src/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Character extends StatefulWidget {
  SharedPreferences prefs;
  Character({super.key, required this.prefs});

  @override
  State<Character> createState() => _CharacterState();
}

class _CharacterState extends State<Character> {
  late bool isMusic, isSfx, isJoystick, isPaari;
  String gretaBtnTxt = "Equip", paariBtnTxt = "Unequip";

  @override
  Widget build(BuildContext context) {
    isMusic = widget.prefs.getBool("isMusic") ?? false;
    isSfx = widget.prefs.getBool("isSfx") ?? false;
    isPaari = widget.prefs.getBool("isPaari") ?? true;
    if (isPaari) {
      gretaBtnTxt = "Equip";
      paariBtnTxt = "Unequip";
    } else {
      paariBtnTxt = "Equip";
      gretaBtnTxt = "Unequip";
    }
    return Scaffold(
      body: Stack(
        children: [
          screenBackground(),
          ListView.builder(
            padding: const EdgeInsets.all(25),
            itemCount: 2,
            itemBuilder: (BuildContext context, int index) {
              return Center(child: characterData(index));
            },
          ),
          backButton(context),
        ],
      ),
    );
  }

  Widget characterData(index) {
    final cardData = [
      [
        "paari.png",
        "Paari",
        "Flash",
        "Named after a Tamil \n"
            "king who loved \n"
            "people and plants. \n"
            "He offered his royal chariot\n"
            " as a support for the \n"
            "jasmine creeper.",
      ],
      [
        "greta.png",
        "Greta",
        "Teleportation",
        "Named After a Young\n"
            "Swedish environmental \n"
            "activist known for challenging \n"
            "world leaders to take immediate \n"
            "action for climate change \n"
            "mitigation.",
      ]
    ];
    List<Color> color = [Colors.blueAccent, Colors.redAccent];
    return Container(
      height: 300,
      width: 650,
      margin: EdgeInsets.all(20),
      child: Card(
        color: Colors.black12,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    child: Image.asset(
                        "assets/images/Profile/${cardData[index][0]}"),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: color[index],
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(color: Colors.white, width: 3.0)),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: Container(
                    color: Colors.white,
                    width: 3,
                    height: 200,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Name ~ ",
                          style: TextStyle(
                              fontFamily: "Edo",
                              color: Colors.red,
                              fontSize: 20),
                        ),
                        Text(
                          '${cardData[index][1]}',
                          style: TextStyle(
                              fontFamily: "Edo",
                              color: Colors.white,
                              fontSize: 20),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Power Up ~ ",
                          style: TextStyle(
                              fontFamily: "Edo",
                              color: Colors.red,
                              fontSize: 20),
                        ),
                        Text(
                          "${cardData[index][2]}",
                          style: TextStyle(
                              fontFamily: "Edo",
                              color: Colors.white,
                              fontSize: 20),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Description ~ ",
                          style: TextStyle(
                              fontFamily: "Edo",
                              color: Colors.red,
                              fontSize: 20),
                        ),
                        Text(
                          "${cardData[index][3]}",
                          style: TextStyle(
                              fontFamily: "Edo",
                              color: Colors.white,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  if (isSfx) FlameAudio.play("menuBtnClick.wav");
                  setState(() {
                    if (isPaari) {
                      gretaBtnTxt = "Equip";
                      paariBtnTxt = "Unequip";
                    } else {
                      paariBtnTxt = "Equip";
                      gretaBtnTxt = "Unequip";
                    }
                  });
                  await widget.prefs.setBool("isPaari", !isPaari);
                  isPaari = !isPaari;
                },
                child: Text(
                  (index == 0) ? paariBtnTxt : gretaBtnTxt,
                  style: TextStyle(color: Colors.red, fontFamily: "Edo"),
                ))
          ],
        ),
      ),
    );
  }

  Widget screenBackground() => Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/Background/Background.png"),
          fit: BoxFit.fill,
        )),
      );

  Widget backButton(BuildContext context) => Positioned(
      top: 10,
      left: 10,
      child: TextButton(
          onPressed: () {
            if (isSfx) FlameAudio.play("menuBtnClick.wav");

            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Home(prefs: widget.prefs)));
          },
          child: Image.asset(
            "assets/images/Controls/close.png",
            width: 32,
            height: 32,
          )));
}
