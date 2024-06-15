import 'package:shared_preferences/shared_preferences.dart';

class Helper
{

  static SharedPreferences? preferences;

  static String spUserToken = "token";
  static String spIsUserLogin = "isLoggedIn";
  static String userType = "none";




  static Future<String?> getUserToken() async{    // get Bearer Token
    preferences = await SharedPreferences.getInstance();
    return preferences!.getString(spUserToken);
  }

  /// get login
  static Future<bool?> getUserLoggedIn() async {
    preferences = await SharedPreferences.getInstance();
    return preferences!.getBool(spIsUserLogin) ?? false;
  }

  /// get user type
  static Future<String?> getUserType() async {
    preferences = await SharedPreferences.getInstance();
    return preferences!.getString(userType);
  }


}