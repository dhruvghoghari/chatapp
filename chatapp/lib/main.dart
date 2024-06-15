import 'package:chatapp/routes/app_routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.getToken().then((token) async{  // Token Generate
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token.toString());
    print("Token---------${token}");
    //Token-------fPxL47CoR4SH4phlp-95OD:APA91bFGArpWIobwzz3nEKSWDJKWb9vPiH3XMJY3UIQYmD8BlrNZBhOgr7uT-hQHnTbaMVDk3xX8svHPPsZXo0gPto-adHnH8cuvuL9NhZb951IW0WTQhWkqbLqXRRlih-aXixaoBFgg
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.home,
        getPages: Routes.getPages,
      ),
    );
  }

}
