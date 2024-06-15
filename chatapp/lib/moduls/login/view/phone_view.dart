import 'package:chatapp/utils/apptheme.dart';
import 'package:chatapp/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/login_controller.dart';
import 'otp_view.dart';

class PhoneView extends StatefulWidget {
  const PhoneView({super.key});

  @override
  State<PhoneView> createState() => _PhoneViewState();
}

class _PhoneViewState extends State<PhoneView> {
  LoginController loginCon = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PhoneView"),),
      body: Column(
        children: [
          Image.asset("assets/img/phoneLogin.png"),
          Text("Enter Verify PhoneNumber ", style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold),
          ),

          AppTheme.customTextfield(
              loginCon.mobileController,
              "Enter Mobile",
              Icons.phone_android,
            false
          ),
          // Button(btnText: "Submit",
          //     onClick: () async{
          //       await FirebaseAuth.instance.verifyPhoneNumber(
          //         verificationCompleted: (PhoneAuthCredential credential) {},
          //         verificationFailed: (FirebaseAuthException ex) {},
          //         codeSent: (String verificationId, int? resendToken) {
          //           Get.to(() => OtpView(),
          //             arguments: {
          //               'verificationId': verificationId,
          //               'email': email,
          //             },
          //           );
          //         },
          //         codeAutoRetrievalTimeout: (String verificationId) {},
          //         phoneNumber: loginCon.mobileController.text.toString(),
          //       );
          // })

        ],
      ),
    );
  }
}
