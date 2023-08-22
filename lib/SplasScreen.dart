import 'package:chatapp/HomeScreen.dart';
import 'package:chatapp/Login.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplasScreen extends StatefulWidget {
  const SplasScreen({Key? key}) : super(key: key);

  @override
  State<SplasScreen> createState() => _SplasScreenState();
}
class _SplasScreenState extends State<SplasScreen> {


  logindata() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("islogin"))
      {
        Navigator.pop(context);
        Navigator.push(context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    else
      {
        Navigator.pop(context);
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      logindata();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.cyan.shade50,
          child: Column(
            children: [
              SizedBox(height: 200.0),
             Lottie.asset("img/animation_ll4poqxq.json"),
              Image.asset("img/Chatbox.png",width: 200.0),
            ],
          ),
        ),
      ),
    );
  }
}
