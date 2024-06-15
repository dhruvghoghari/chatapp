import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MessagingService {

  static String? fcmToken;
  static final MessagingService _instance = MessagingService._internal();
  factory MessagingService() => _instance;
  MessagingService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  Future<void> init(BuildContext context) async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    debugPrint('User granted notifications permission: ${settings.authorizationStatus}');
    fcmToken = await _fcm.getToken();
    log("fcmToken-----------------${fcmToken}");
   //fcmToken-----------------fPxL47CoR4SH4phlp-95OD:APA91bFGArpWIobwzz3nEKSWDJKWb9vPiH3XMJY3UIQYmD8BlrNZBhOgr7uT-hQHnTbaMVDk3xX8svHPPsZXo0gPto-adHnH8cuvuL9NhZb951IW0WTQhWkqbLqXRRlih-aXixaoBFgg

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.notification!.title.toString()}');
      if (message.notification != null) {
        if (message.notification!.title != null &&
            message.notification!.body != null) {
          final notificationData = message.data;
          final screen = notificationData['screen'];
        }
      }
    });
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationClick(context, message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('onMessageOpenedApp: ${message.notification!.title.toString()}');
      _handleNotificationClick(context, message);
    });
  }
  void _handleNotificationClick(BuildContext context, RemoteMessage message) {
    final notificationData = message.data;
    if (notificationData.containsKey('screen')) {
      final screen = notificationData['screen'];
      Navigator.of(context).pushNamed(screen);
    }
  }
}
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message: ${message.notification!.title}');
}


// import 'dart:developer';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class LocalNotificationService {
//   static final FlutterLocalNotificationsPlugin notificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   static void initialize() {
//     final InitializationSettings initializationSettings =
//     InitializationSettings(
//         android: AndroidInitializationSettings("@mipmap/ic_launcher"));
//     notificationsPlugin.initialize(initializationSettings);
//   }
//
//   static Future<void> createNotification(RemoteMessage message) async {
//     try {
//       final id = DateTime.now().microsecondsSinceEpoch ~/ 1000;
//       const NotificationDetails notificationDetails = NotificationDetails(
//           android: AndroidNotificationDetails(
//             "com.example.chatapp", "com.example.chatapp",
//             importance: Importance.max,
//             priority: Priority.high,
//           ));
//       await notificationsPlugin.show(id, message.notification!.title,
//           message.notification!.body, notificationDetails);
//     } on Exception catch (e) {
//       print(e);
//     }
//   }
// }
//
// class FirebaseNotificationService {
//   late final FirebaseMessaging messaging;
//
//   Future<void> settingNotification() async {
//     await messaging.requestPermission(
//       alert: true,
//       sound: true,
//       badge: true,
//     );
//   }
//
//   Future<void> connectionNotification() async {
//     await Firebase.initializeApp();
//     messaging = FirebaseMessaging.instance;
//
//     messaging.setForegroundNotificationPresentationOptions(
//       alert: true,
//       sound: true,
//       badge: true,
//     );
//
//     await settingNotification();
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       if (message.notification != null) {
//         LocalNotificationService.createNotification(message);
//       }
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       test(message);
//     });
//     messaging
//         .getToken()
//         .then((value) => log('Token : $value', name: 'FCM Token'));
//   }
//
//   void test(RemoteMessage message) {
//     if (message.notification != null) {
//       backgroundMessage(message);
//     }
//   }
//
//   static Future<void> backgroundMessage(RemoteMessage message) async {
//     await Firebase.initializeApp();
//     print('handling a background message');
//   }
//
// }
