import 'package:chatapp/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {


  checkLogin() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("isLogin"))
    {
      Get.offAllNamed(Routes.home);
    }
    else
    {
      Get.offAllNamed(Routes.login);
    }
  }

}
