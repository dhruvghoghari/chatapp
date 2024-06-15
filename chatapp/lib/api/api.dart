import 'dart:convert';
import 'package:chatapp/api/widget.dart';
import 'package:chatapp/utils/constrants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/helper.dart';

class Api{

  Dio dio = Dio (BaseOptions(
    baseUrl:Constants.baseUrl,
    contentType: "application/json",
  ));

  Future? header() async {
    String? token;
    await Helper.getUserToken().then((value) {
      token = value;
    });
    if (kDebugMode) {
      print(token);
    }
    return dio.options.headers["Authorization"] = "Bearer $token";
  }

  Future? getUserLogin({String? email,String? password}) async {
    Map<String,dynamic> map = {"email":email,"password":password};
    String body= jsonEncode(map);
    try{
      var headers = {
        'Content-Type': 'application/json',
      };
      var response = await dio.post('login',data: body,options: Options(headers: headers));
      if(response.statusCode == 200 || response.statusCode == 201){
        if(response.data["user"] != null){

          var name = response.data['user']['name'];
          var role = response.data['user']['role'];
          var mobile = response.data['user']['phoneNumber'];
          var token = response.data['token'];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("isLogin", "yes");
          prefs.setString('name', name);
          prefs.setString('email', email!);
          prefs.setString('phoneNumber',mobile);
          prefs.setString('role', role);
          prefs.setString('token', token);
          
          return response.data;
        }
      }

    }
    on DioException catch(ex){
      return apiDialog(ex.response!.data['message'] ?? "Please try again");
    }
  }

  Future? sendPushNotification({String? title, String? body, String? to }) async {
    Map<String,dynamic> map = {"notification":{"title":title,"body":body},"to":to};
    String requestBody = jsonEncode(map);

    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer AAAAKZ9-00w:APA91bG60aXsIIJSQhTfC1-aUctV6JNj4LR280H4GDyNgnnsrwItJXfCSR1sO7Ao7E_sZKXpw5n21-oyZn7FP3KamOt2mTdZK2V4dWun7jOR8W3eaEx1Hsw_nc9VQ8RK4tA7M_6w0Tko'
      };
      var response = await dio.post('https://fcm.googleapis.com/fcm/send',
        data: requestBody,
        options: Options(headers: headers),
      );

      if(response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
    }
    on DioException catch (ex) {
      print('sendPushNotificationE: $ex');
    }
  }

  // String getTimeDifferenceString(int timestamp) {
  //   DateTime now = DateTime.now();
  //   DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  //
  //   Duration difference = now.difference(dateTime);
  //   if (difference.inSeconds < 60) {
  //     return 'Just now';
  //   } else if (difference.inMinutes < 2) {
  //     return '1 min ago';
  //   } else if (difference.inDays < 31) {
  //     return '${difference.inDays} days ago';
  //   } else {
  //     DateFormat formatter = DateFormat('DD MMM yyyy');
  //     return formatter.format(dateTime);
  //   }
  // }

  // void main() {
  //   int timestampJustNow = DateTime.now().millisecondsSinceEpoch;
  //   int timestamp1MinAgo = DateTime.now().subtract(Duration(minutes: 1)).millisecondsSinceEpoch;
  //   int timestamp1MonthAgo = DateTime.now().subtract(Duration(days: 30)).millisecondsSinceEpoch;
  //
  //   print(getTimeDifferenceString(timestampJustNow));
  //   print(getTimeDifferenceString(timestamp1MinAgo));
  //   print(getTimeDifferenceString(timestamp1MonthAgo));
  // }


  // Online/Offline

//   class UserPresenceService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final CollectionReference _presenceCollection = FirebaseFirestore.instance.collection('user');
//
//   Future<void> setUserOnline() async {
//   final User? user = _auth.currentUser;
//   if (user != null) {
//   await _presenceCollection.doc(user.uid).set({
//   'isOnline': true,
//   'lastSeen': DateTime.now(),
//   });
//   }
//   }
//
//   Future<void> setUserOffline() async {
//   final User? user = _auth.currentUser;
//   if (user != null) {
//   await _presenceCollection.doc(user.uid).set({
//   'isOnline': false,
//   'lastSeen': DateTime.now(),
//   });
//   }
//   }
//
//   Stream<DocumentSnapshot> getUserPresenceStream(String userId) {
//   return _presenceCollection.doc(userId).snapshots();
//   }
//   }
//
// // Usage
//   void main() async {
//   UserPresenceService presenceService = UserPresenceService();
//
//   await presenceService.setUserOnline();
//
//   String userId = FirebaseAuth.instance.currentUser!.uid;
//   Stream<DocumentSnapshot> userPresenceStream = presenceService.getUserPresenceStream(userId);
//   userPresenceStream.listen((DocumentSnapshot snapshot) {
//   bool isOnline = snapshot['isOnline'];
//   print('User is ${isOnline ? 'online' : 'offline'}');
//   });
//   }

}

