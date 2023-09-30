import 'package:chatapp/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color(0xff301547),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 10.0,),
                      Image.asset("img/Group 477 (1).png"),
                      Text("Chatbox",style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                      ),),
                      Row(
                        children: [
                          SizedBox(width: 20.0,),
                          Image.asset("img/Connect friends easily & quickly (1).png",height: 300.0,)
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            // SizedBox(width: 40.0,),
                            Image.asset("img/chatt.png")
                          ],
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: 10.0),
                  // Row(
                  //   children: [
                  //     SizedBox(width: 100.0,),
                  //     Image.asset("img/fb.png",width: 70.0,),
                  //     Image.asset("img/gp.png"),
                  //     Image.asset("img/apple.png"),
                  //   ],
                  // ),
                  // SizedBox(height: 20.0),
                  // Image.asset("img/OR (2).png"),
                  SizedBox(height: 120.0),
                  Container(
                    width: 320.0,
                    height: 55.0,
                    child: ElevatedButton(
                      onPressed: ()  async{

                        final GoogleSignIn googleSignIn = GoogleSignIn();
                        final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
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
                          var googleid = user.uid.toString();

                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString("name",name);
                          prefs.setString("islogin","yes");
                          prefs.setString("email",email);
                          prefs.setString("photo",photo);
                          prefs.setString("googleid",googleid);

                          // firebase Insert data

                          //check
                          await FirebaseFirestore.instance.collection("user").where("email",isEqualTo: email).get().then((documents) async{
                            if(documents.size <=0 )
                              {
                                await FirebaseFirestore.instance.collection("user").add({
                                  "name":name,
                                  "email":email,
                                  "photo":photo,
                                  "googleid":googleid,
                                }).then((document) async{

                                  SharedPreferences prefs=await SharedPreferences.getInstance();
                                  prefs.setString("senderid", document.id.toString());

                                  Navigator.pop(context);
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => HomeScreen(),
                                    ),
                                  );
                                });
                              }
                            else
                              {
                                SharedPreferences prefs=await SharedPreferences.getInstance();
                                prefs.setString("senderid", documents.docs.first.id.toString());

                                Navigator.pop(context);
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => HomeScreen(),
                                  ),
                                );
                              }
                          });
                        }

                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                      ),
                      child: Text("Login With Google",style: TextStyle(
                      color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0
                      ),),
                    ),
                  ),
                  SizedBox(height: 25.0),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Existing account ? ',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        TextSpan(
                          text: 'Log In ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
