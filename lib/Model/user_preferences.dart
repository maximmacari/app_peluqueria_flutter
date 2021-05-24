import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instancia = new UserPreferences._internal();

  factory UserPreferences() {
    return _instancia;
  }

  UserPreferences._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    if (_prefs == null) {
      this._prefs = await SharedPreferences.getInstance();
    }
  }

  // GET y SET del presentationSeen,
  //** Evaluates which screen to present on start of the app
  // true: first screen will be Services
  // false: first screen will be onBoarding
  // */
  get presentationSeen {
    return _prefs.getBool('presentationSeen') ?? '';
  }

  set presentationSeen(bool value) {
    _prefs.setBool('presentationSeen', value);
  }
}
