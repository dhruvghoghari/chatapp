import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/apptheme.dart';
import '../../../widgets/button.dart';
import '../controller/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  LoginController loginCon = Get.put(LoginController());
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 100;
    double width = MediaQuery.of(context).size.width * 100;
    return Scaffold(
      appBar: AppBar(title: Text("LoginView"),),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() {
                return Form(
                  key: loginCon.loginKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 30,),
                        TextFormField(
                          controller: loginCon.email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: AppTheme.customDecoration(
                              "Enter Email", Icons.email),
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          controller: loginCon.password,
                          obscureText: loginCon.passwordVisible.value,
                          decoration: AppTheme.customDecoration(
                              "Enter the password", Icons.lock
                          ).copyWith(
                            suffixIcon: InkWell(
                              onTap: () {
                                loginCon.passwordVisibility();
                              },
                              child: Icon(
                                loginCon.passwordVisible.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          //validator: loginCon.customPasswordValidation,
                        ),
                        Align(alignment: Alignment.centerRight,
                          child: GestureDetector(onTap: () {},
                            child: Text("Forgot Password?", style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                            ),),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Button(btnText: "Login", onClick: () async {
                          // if(loginCon.email.text.isEmpty || loginCon.password.text.isEmpty){
                          //   AppTheme.getSnackBar(message: "Enter Reqiured Field");
                          // }
                          // else{
                          //  await loginCon.api.getUserLogin(
                          //    email:loginCon.email.text,
                          //    password: loginCon.password.text,
                          //  )!.then((value) async{
                          //    if(loginCon.isLogin.value = true)
                          //      {
                          //        AppTheme.getSnackBar(message: value['message']);
                          //        SharedPreferences prefs = await SharedPreferences.getInstance();
                          //        prefs.setString('isLogin','yes');
                          //      }
                          //    else
                          //      {
                          //        AppTheme.getSnackBar(message: value['message']);
                          //      }
                          //    loginCon.email.clear();
                          //    loginCon.password.clear();
                          //    Get.back();
                          //    Get.offAllNamed(Routes.home);
                          //  });
                          //
                          // }

                        }),
                        SizedBox(height: 20,),
                        GestureDetector(onTap: () async {
                          final GoogleSignIn googleSignIn = GoogleSignIn();
                          final GoogleSignInAccount? googleSignInAccount = await googleSignIn
                              .signIn();
                          if (googleSignInAccount != null) {
                            final GoogleSignInAuthentication googleSignInAuthentication =
                            await googleSignInAccount.authentication;
                            final AuthCredential authCredential = GoogleAuthProvider.credential(
                                idToken: googleSignInAuthentication.idToken,
                                accessToken: googleSignInAuthentication.accessToken);

                            UserCredential result = await auth.signInWithCredential(authCredential);
                            User user = result.user!;

                            var name = user.displayName.toString();
                            var email = user.email.toString();
                            var photo = user.photoURL.toString();

                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString("name", name);
                            prefs.setString("isLogin", "yes");
                            prefs.setString("email", email);
                            prefs.setString("photo", photo);

                            await FirebaseFirestore.instance.collection('user').where("email", isEqualTo: email).get().then((documents) async {
                              if (documents.size <= 0) {
                                await FirebaseFirestore.instance.collection('user').add({
                                  "name": name,
                                  "email": email,
                                  "photo": photo,
                                  "token": prefs.getString("token").toString(),
                                  //"status":"Unavailable",
                                }).then((documents) async {

                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setString("senderId", documents.id.toString());
                                  print("senderId${documents.id.toString()}");

                                  Get.offAllNamed(Routes.home);
                                });
                              }
                              else {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setString("senderId", documents.docs.first.id.toString());

                                Get.offAllNamed(Routes.home);
                              }
                            });
                          }
                        },
                          child: Container(
                            width: width * 80,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Image.asset("assets/img/Google.jpg"),
                                ),
                                Text("Continue with Google", style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                )),
                              ],
                            ),
                          ),
                        ),
                        // SizedBox(height: 20,),
                        // GestureDetector(onTap: () async {
                        //
                        // },
                        //   child: Container(
                        //     width:width * 82,
                        //     decoration: BoxDecoration(
                        //       color: Colors.grey.shade200,
                        //       borderRadius: BorderRadius.circular(20.0),
                        //     ),
                        //     child: Row(
                        //       children: [
                        //         Padding(
                        //           padding: const EdgeInsets.all(15.0),
                        //           child: Image.asset("assets/img/Facebook.jpg"),
                        //         ),
                        //         Text("Continue with Facebook",style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: 20.0,
                        //         )),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(height: 20,),
                        // GestureDetector(onTap: () async {
                        //   Get.to(() => PhoneView());
                        // },
                        //   child: Container(
                        //     width:width * 82,
                        //     decoration: BoxDecoration(
                        //       color: Colors.grey.shade200,
                        //       borderRadius: BorderRadius.circular(20.0),
                        //     ),
                        //     child: Row(
                        //       children: [
                        //         Padding(
                        //           padding: const EdgeInsets.all(15.0),
                        //           child: Image.asset("assets/img/phone.png",height:30),
                        //         ),
                        //         Text("Continue with Phone",style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: 20.0,
                        //         )),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
