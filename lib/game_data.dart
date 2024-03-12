import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameData extends ChangeNotifier {
  late bool _isSfx, _isMusic, _isJoystick, _isPaari;
  late int _waterDrops;
  late String _charPath;
  late SharedPreferences prefs;
  late String _paariBtnTxt;
  late String _gretaBtnTxt;

  GameData() {
    _isSfx = false;
    _isMusic = false;
    _isJoystick = false;
    _isPaari = true;
    _paariBtnTxt = "unequip";
    _gretaBtnTxt = "equip";
    _waterDrops = 15;
    _charPath = "assets/images/Menu/Buttons/paari_character_button.png";
    _loadFromPrefs();
  }
  _loadFromPrefs() async {
    prefs = await SharedPreferences.getInstance();
    _waterDrops = prefs.getInt("_waterDrops") ?? 15;
    _isSfx = prefs.getBool("_isSfx") ?? false;
    _isMusic = prefs.getBool("_isMusic") ?? false;
    _isJoystick = prefs.getBool("_isJoystick") ?? false;
    _isPaari = prefs.getBool("_isPaari") ?? true;
    notifyListeners();
  }

  int get waterDrops => _waterDrops;

  bool get isSfx => _isSfx;
  bool get isMusic => _isMusic;
  bool get isJoystick => _isJoystick;
  bool get isPaari => _isPaari;

  String get charPath => _charPath;
  String get paariBtnTxt => _paariBtnTxt;
  String get gretaBtnTxt => _gretaBtnTxt;

  changeCharacter() {
    if (_isPaari) {
    } else {}
  }

  toggleIsPaari() {
    if (_isPaari) {
      _gretaBtnTxt = "unequip";
      _paariBtnTxt = "equip";
      _charPath = "assets/images/Menu/Buttons/paari_character_button.png";
    } else {
      _gretaBtnTxt = "equip";
      _paariBtnTxt = "unequip";
      _charPath = "assets/images/Menu/Buttons/greta_character_button.png";
    }
    _isPaari = !_isPaari;
    notifyListeners();
  }

  toggleIsMusic() async {
    _isMusic = !_isMusic;
    await prefs.setBool("_isMusic", !_isMusic);
    notifyListeners();
  }

  toggleIsSfx() async {
    _isSfx = !_isSfx;
    await prefs.setBool("_isSfx", !_isSfx);
    notifyListeners();
  }

  toggleIsJoyStick() async {
    _isJoystick = !_isJoystick;
    prefs.setBool("_isJoystick", !_isJoystick);
    notifyListeners();
  }
}
