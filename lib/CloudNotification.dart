import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CloudNotification extends StatefulWidget {
  const CloudNotification({Key? key}) : super(key: key);

  @override
  State<CloudNotification> createState() => _CloudNotificationState();
}

class _CloudNotificationState extends State<CloudNotification> {

  var id="";


  getdata() async
  {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    setState(() {
      id=prefs.getString("token").toString();
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(id)
          ],
        ),
      ),
    );
  }
}
