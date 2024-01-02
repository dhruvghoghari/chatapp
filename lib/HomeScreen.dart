import 'package:chatapp/Chats.dart';
import 'package:chatapp/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var name = "";
  var email ="";
  var photo ="";
  var googleid ="";

  getdata() async
  {
    SharedPreferences prefs =await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name").toString();
      email= prefs.getString("email").toString();
      photo= prefs.getString("photo").toString();
      googleid= prefs.getString("googleid").toString();
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
      appBar: AppBar(
        title: Text("Home "),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async{

              SharedPreferences prefs = await SharedPreferences.getInstance(); // shared Prefrense clear
              prefs.clear();

              GoogleSignIn googleSignIn = GoogleSignIn();                       // Google sign out
              googleSignIn.signOut();

              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Login())
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                  child: Image.network(photo)
              ),
              accountName: Text("Name :- "+name),
              accountEmail: Text("Email :- "+email),
            ),
            ListTile(
              title: Text("Google id :- "+googleid,style: TextStyle(
                  fontSize: 20.0
              ),),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey.shade200,
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("user").where("email",isNotEqualTo: email).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
                    {
                      if(snapshot.hasData)
                        {
                          if(snapshot.data!.size <=0)
                            {
                              return Center(
                                child: Text("img/Nodata.jpg"),
                              );
                            }
                          else
                            {
                              return ListView(
                                shrinkWrap: true,
                                children: snapshot.data!.docs.map((document){
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(document["photo"].toString()),
                                      radius: 30,
                                    ),
                                    title: Text(document["name"].toString()),
                                    subtitle: Text(document["email"].toString()),
                                    onTap: () {
                                      var nm = document["name"].toString();
                                      var em = document["email"].toString();
                                      var pt = document["photo"].toString();


                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => Chats(
                                          name:nm,
                                          email: em,
                                          photo:pt,
                                          receiverid: document.id.toString(),
                                        ))
                                      );
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
