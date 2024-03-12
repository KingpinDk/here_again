import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:here_again/app_src/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt("waterDrops", 30);
  WidgetsFlutterBinding.ensureInitialized();

  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        primaryColor: Colors.white30,
        splashColor: Colors.white30,
        hoverColor: Colors.white30),
    home: Home(
      prefs: prefs,
    ),
  ));
}
