import 'package:here_again/app_src/home.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.white30,
            splashColor: Colors.white30,
            hoverColor: Colors.white30
          ),
          home:Home(),
      )
  );
}


