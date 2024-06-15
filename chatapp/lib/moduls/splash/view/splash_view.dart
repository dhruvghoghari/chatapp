import 'package:chatapp/moduls/splash/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';


class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  SplashController splashCon = Get.put(SplashController());




  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      splashCon.checkLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height * 100;
    // double width = MediaQuery.of(context).size.width * 100;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.cyan.shade50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset("assets/animation/chatApp_animation.json"),
              Image.asset("assets/img/ChatBox.png",width: 200.0),
            ],
          ),
        ),
      ),
    );
  }
}
