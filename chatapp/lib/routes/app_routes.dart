import 'package:chatapp/moduls/chats/bindings/chats_binding.dart';
import 'package:chatapp/moduls/chats/view/chats_view.dart';
import 'package:chatapp/moduls/home/bindings/home_binding.dart';
import 'package:chatapp/moduls/home/view/home_view.dart';
import 'package:chatapp/moduls/login/bindings/login_binding.dart';
import 'package:chatapp/moduls/login/view/login_view.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import '../moduls/splash/bindings/splash_binding.dart';
import '../moduls/splash/view/splash_view.dart';

class Routes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String chats = '/chats';


  static List<GetPage<dynamic>> get getPages {
    return [
      GetPage(
        name: Routes.splash,
        page: () => SplashView(),
        binding: SplashBinding(),
      ),
      GetPage(
        name: Routes.login,
        page: () => LoginView(),
        binding: LoginBinding(),
      ),
      GetPage(
        name: Routes.home,
        page: () => HomeView(),
        binding: HomeBinding(),
      ),
      GetPage(
        name: Routes.chats,
        page: () => ChatsView(),
        binding: ChatsBinding(),
      )

    ];
  }
}
