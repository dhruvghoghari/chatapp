import 'package:chatapp/routes/app_routes.dart';
import 'package:chatapp/utils/apptheme.dart';
import 'package:chatapp/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart';

class OtpView extends StatefulWidget {

  @override
  State<OtpView> createState() => _OtpViewState();
}
class _OtpViewState extends State<OtpView> {


  @override
  Widget build(BuildContext context) {
    LoginController loginCon = Get.put(LoginController());

    return Scaffold(
      appBar: AppBar(
        title: Text("OtpScreen"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(child: Image.asset("img/phonelogin.png")),
              Text("A 4 digit code has been sent to example@gmail.com",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              AppTheme.customTextfield(loginCon.otpController, "Enter otp", (Icons.output), false),
              SizedBox(height: 30.0),
              // Button(btnText: "Verify", onClick: () async{
              //
              //   try {
              //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
              //       verificationId: loginCon.verificationId.value,
              //       smsCode: loginCon.otpController.text.toString(),
              //     );
              //     UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
              //    Get.offAllNamed(Routes.home);
              //   }
              //   catch (ex){
              //     if (kDebugMode) {
              //       print('Verification failed: $ex');
              //     }
              //   }
              // })
            ],
          ),
        ),
      ),
    );
  }
}
