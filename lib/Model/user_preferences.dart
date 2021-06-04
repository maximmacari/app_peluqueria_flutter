import 'package:shared_preferences/Shared_preferences.dart';

class UserPreferences {
  static const String PRESENTATION_SEEN = "presentation_seen";
  static const String SELECTED_SUBGROUP = "selected_subgroup";
  static Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();
  static SharedPreferences _prefs;

  static Future<SharedPreferences> initPrefs() async {
    _prefs = await _instance;
    return _prefs;
  }

  //** Evaluates which screen to present on start of the app
  // true: first screen will be Services
  // false: first screen will be onBoarding, only one time
  // */
  static getPresentationSeen() {
    return _prefs.getBool(PRESENTATION_SEEN) ?? false;
  }

  static setPresentationSeen(bool value) {
    _prefs.setBool(PRESENTATION_SEEN, value);
  }

  
  static setSelectedSubGroup(String newValue){
    _prefs.setString(SELECTED_SUBGROUP, newValue);
  }

  static getSelectedSubGroup(){
    return _prefs.getString(SELECTED_SUBGROUP) ?? "cortes";
  }
}
