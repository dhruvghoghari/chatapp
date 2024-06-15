import 'package:chatapp/moduls/home/controller/home_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_routes.dart';
import '../../chats/view/chats_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  HomeController homeCon = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    setState(() {
      homeCon.googleData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                  child: Image.network(homeCon.photo.value)
              ),
              accountName: Text(homeCon.name.value),
              accountEmail: Text(homeCon.email.value),
            ),
            SizedBox(height: 400),
            GestureDetector(
              onTap: () async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();

                GoogleSignIn googleSignIn = GoogleSignIn();  // Google logout
                googleSignIn.signOut();

                Get.back();
                Get.offAllNamed(Routes.login);
              },
              child: Padding(
                padding:  const EdgeInsets.all(20.0),
                child: Container(
                  padding:  const EdgeInsets.symmetric(vertical: 10.0,horizontal: 50.0),
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.blue.shade50
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Logout",textAlign: TextAlign.center,style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey
                      ),),
                      Icon(Icons.arrow_forward,color: Colors.grey
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("HomeView"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey.shade200,
        child: Column(
          children: [
            Obx(() {
              return
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("user").where("email",isNotEqualTo: homeCon.email.value).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
                  {
                    if(snapshot.hasData)
                    {
                      if(snapshot.data!.size<=0)
                      {
                        return Center(
                          child: Text("No Data"),
                        );
                      }
                      else
                      {
                        return ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: snapshot.data!.docs.map((document){
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(document["photo"].toString()),
                                radius: 30,
                              ),
                              title: Text(document["name"].toString()),
                              subtitle: Text(document["email"].toString()),

                              onTap: () {
                                var name = document["name"].toString();
                                var email = document["email"].toString();
                                var photo = document["photo"].toString();
                                var token = document["token"].toString();
                                //var status = document["Unavailable"].toString();
                                Get.to(() => ChatsView(), arguments: {
                                  'name': name,
                                  'email': email,
                                  'photo': photo,
                                  'token':token,
                                  'receiverId':document.id.toString(),
                                  //'Unavailable':status
                                });
                              },
                            );
                          }).toList(),
                        );
                      }
                    }
                    else
                    {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
              );
            })
          ],
        ),
      ),
    );
  }
}
