import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chatapp/NotificationExample.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Chats.dart';
import 'CloudNotification.dart';
import 'HomeScreen.dart';
import 'Login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'SplasScreen.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AwesomeNotifications().initialize(
      'resource://drawable/logo',    // Notification logo
      [
        NotificationChannel(
            channelKey: 'alerts',
            channelName: 'Alerts',
            channelDescription: 'Notification tests as alerts',
            playSound: true,
            onlyAlertOnce: true,
            groupAlertBehavior: GroupAlertBehavior.Children,
            importance: NotificationImportance.High,
            defaultPrivacy: NotificationPrivacy.Private,
            defaultColor: Colors.green,
            ledColor: Colors.green),
        NotificationChannel(
            channelKey: 'img',
            channelName: 'image notification ',
            channelDescription: 'Notification tests as alerts',
            playSound: true,
            onlyAlertOnce: true,
            groupAlertBehavior: GroupAlertBehavior.Children,
            importance: NotificationImportance.High,
            defaultPrivacy: NotificationPrivacy.Private,
            defaultColor: Colors.grey,
            ledColor: Colors.red),
        NotificationChannel(
            channelKey: 'image',
            channelName: 'notification ',
            channelDescription: 'Notification tests as alerts',
            playSound: true,
            onlyAlertOnce: true,
            groupAlertBehavior: GroupAlertBehavior.Children,
            importance: NotificationImportance.High,
            defaultPrivacy: NotificationPrivacy.Private,
            defaultColor: Colors.grey,
            ledColor: Colors.red),
      ],
      debug: true);
  await FirebaseMessaging.instance.getToken().then((token) async{   // Token Generate
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.setString("token", token.toString());
  });

  FirebaseMessaging.onMessage.listen(showFlutterNotification);


  runApp(const MyApp());
}
void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {

    var firebasetitle  = notification.title.toString();
    var firebasebody = notification.body.toString();

    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'alerts',
          title: firebasetitle,
          body: firebasebody,
        )
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home:SplasScreen(),
    );
  }
}
