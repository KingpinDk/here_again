import 'package:flutter/material.dart';

class Character extends StatelessWidget {
  const Character({super.key});

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
          ListView.builder(
            padding: EdgeInsets.all(25),
            itemCount: 2,
            itemBuilder: (BuildContext context, int index) {
              return Center(child: characterData(index));
            },
          )
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
            ElevatedButton(onPressed: () {}, child: Text("Equipped"))
          ],
        ),
      ),
    );
  }
}
