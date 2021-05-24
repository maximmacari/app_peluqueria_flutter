import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  // codingwithdhrumil  flutter shared prefereences example
  static final UserPreferences _instance = new UserPreferences._internal();

  static const String PRESENTATTION_SEEN = "presentation_seen";

  factory UserPreferences() => _instance ?? UserPreferences._internal();

  UserPreferences._internal();

  static SharedPreferences _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del presentationSeen,
  //** Evaluates which screen to present on start of the app
  // true: first screen will be Services
  // false: first screen will be onBoarding
  // */
  get presentationSeen {
    return _prefs.getBool(PRESENTATTION_SEEN) ?? false;
  }

  set presentationSeen(bool value) {
    _prefs.setBool(PRESENTATTION_SEEN, value);
  }
}
