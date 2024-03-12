import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Settings extends StatefulWidget {
  SharedPreferences prefs;
  Settings({super.key, required this.prefs});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late bool isMusic, isSfx, isJoystick, isPaari;
  late Icon sfxIcon;
  late Icon musicIcon;

  late String musicStr;
  late String sfxStr;

  late String controlStr;
  @override
  Widget build(BuildContext context) {
    isMusic = widget.prefs.getBool("isMusic") ?? false;
    isSfx = widget.prefs.getBool("isSfx") ?? false;
    isJoystick = widget.prefs.getBool("isJoystick") ?? false;
    isPaari = widget.prefs.getBool("isPaari") ?? true;
    if (isJoystick) {
      controlStr = "JoyStick ON";
    } else {
      controlStr = "JoyStick OFF";
    }
    if (isSfx) {
      sfxIcon = const Icon(
        Icons.volume_up_rounded,
        color: Colors.redAccent,
      );
      sfxStr = "Sound Effects ON";
    } else {
      sfxIcon = sfxIcon = const Icon(
        Icons.volume_mute_rounded,
        color: Colors.redAccent,
      );
      sfxStr = "Sound Effects OFF";
    }
    if (isMusic) {
      musicIcon = const Icon(
        Icons.music_note_rounded,
        color: Colors.redAccent,
      );
      musicStr = "Music ON";
    } else {
      musicIcon = const Icon(
        Icons.music_off_rounded,
        color: Colors.redAccent,
      );
      musicStr = "Music OFF";
    }
    return Scaffold(
      body: Stack(
        children: [
          screenBackground(),
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  sfxSettings(),
                  musicSettings(),
                  controlSettings(),
                ],
              ),
            ),
          ),
          backButton(context),
        ],
      ),
    );
  }

  Widget backButton(BuildContext context) => Positioned(
      top: 0,
      left: 0,
      child: TextButton(
          onPressed: () {
            if (isSfx) {
              FlameAudio.play("menuBtnClick.wav");
            }
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Home(prefs: widget.prefs)));
          },
          child: Image.asset(
            "assets/images/Controls/close.png",
            width: 32,
            height: 32,
          )));
  Widget screenBackground() => Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/Background/Background.png"),
          fit: BoxFit.fill,
        )),
      );

  Widget controlSettings() {
    Icon controlIcon = Icon(
      Icons.control_camera_rounded,
      color: Colors.redAccent,
    );
    return MyTile(Colors.white12, controlIcon, controlStr, Colors.white38,
        () async {
      setState(() {
        if (isJoystick) {
          controlStr = "JoyStick OFF";
        } else {
          controlStr = "JoyStick ON";
        }
      });
      await widget.prefs.setBool("isJoystick", !isJoystick);
      isJoystick = !isJoystick;
    });
  }

  Widget musicSettings() {
    return MyTile(Colors.white12, musicIcon, musicStr, Colors.white38,
        () async {
      if (isMusic) {
        setState(() {
          musicIcon = const Icon(
            Icons.music_off_rounded,
            color: Colors.redAccent,
          );
          musicStr = "Music OFF";
        });
        FlameAudio.bgm.stop();
      } else {
        setState(() {
          musicIcon = const Icon(
            Icons.music_note_rounded,
            color: Colors.redAccent,
          );
          musicStr = "Music ON";
        });
        FlameAudio.bgm.play("13-Mystical.wav", volume: 0.5);
      }

      await widget.prefs.setBool("isMusic", !isMusic);
      isMusic = !isMusic;
    });
  }

  Widget sfxSettings() {
    return MyTile(Colors.white12, sfxIcon, sfxStr, Colors.white38, () async {
      if (isSfx) {
        setState(() {
          sfxIcon = const Icon(
            Icons.volume_mute_rounded,
            color: Colors.redAccent,
          );
          sfxStr = "Sound Effects OFF";
        });
      } else {
        setState(() {
          sfxIcon = const Icon(
            Icons.volume_up_rounded,
            color: Colors.redAccent,
          );
          sfxStr = "Sound Effects ON";
        });
      }

      await widget.prefs.setBool("isSfx", !isSfx);
      isSfx = !isSfx;
    });
  }

  Widget MyTile(
      Color tileColor, Icon icon, String str, Color fontColor, function) {
    return Container(
      margin: EdgeInsets.all(20),
      height: 70,
      decoration: BoxDecoration(
          color: tileColor,
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          shape: BoxShape.rectangle),
      child: Center(
        child: ListTile(
          leading: icon,
          title: Text(str),
          onTap: function,
          titleTextStyle:
              TextStyle(fontSize: 20.0, color: fontColor, fontFamily: "Edo"),
        ),
      ),
    );
  }
}
