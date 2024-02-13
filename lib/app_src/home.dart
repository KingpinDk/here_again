import 'dart:io';
import 'package:here_again/app_src/levels.dart';
import 'package:flame/widgets.dart';
import 'package:here_again/app_src/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:window_size/window_size.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    if(!kIsWeb){
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        setWindowTitle('Blind Path');

        setWindowMinSize(const Size(640, 360));
      }
    }
    return Scaffold(
      resizeToAvoidBottomInset:false,
      //backgroundColor: Colors.black,
      body: Center(
          child:SingleChildScrollView(
            child: Row(

              children: [Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ButtonTile("Profile",const Icon(Icons.account_circle_rounded, color: Colors.black,), Profile()),
                  ButtonTile("Daily Wheel",const Icon(Icons.add_card_rounded, color: Colors.black),Profile()),
                  ButtonTile("Collectibles",const Icon(Icons.auto_awesome_motion_sharp, color: Colors.black), Profile()),
                  ButtonTile("Lucky Draw",const Icon(Icons.auto_awesome, color: Colors.black), Levels()),

                ],
              ),
                //SpriteButton.asset(onPressed: onPressed, path: '', pressedPath: '', width: null, height: null, label: null, )
              ]
            ),
          )
      ),
    );
  }

  void goToPage(BuildContext context, Widget nextPage) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => nextPage)
    );
  }

  Widget ButtonTile(String title, Widget widget, Widget Page){
    return Center(
      child: Container(

        constraints: BoxConstraints.tightFor(width: 180, height: 30),
        child: ListTile(
          onTap: ()=>goToPage(context, Page),
          title: Text(title),
          leading: widget,
        ),
      ),
    );
  }
}



