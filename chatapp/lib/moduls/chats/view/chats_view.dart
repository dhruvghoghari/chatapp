import 'dart:io';
import 'package:chatapp/moduls/chats/controller/chats_controller.dart';
import 'package:chatapp/moduls/home/controller/home_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


class ChatsView extends StatefulWidget {
  const ChatsView({super.key});

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> with WidgetsBindingObserver{
  HomeController homeCon = Get.put(HomeController());
  ChatsController chatsCon = Get.put(ChatsController());
  final ImagePicker picker = ImagePicker();
  File? selectedFile;


  // final FirebaseAuth auth = FirebaseAuth.instance;
  // final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  //
  //
  // void setStatus(String status) async {
  //   await _fireStore.collection('user').doc(auth.currentUser!.uid).update({
  //     "status": status,
  //   });
  // }
  //
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     setStatus("Online");
  //   } else {
  //     setStatus("Offline");
  //   }
  // }


  @override
  void initState() {
    super.initState();
    homeCon.getSenderId();
    // WidgetsBinding.instance.addObserver(this);
    // setStatus("online");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: (){
                          Get.back();
                        },
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(chatsCon.photo.value),
                        radius: 20,
                      ),
                      SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(chatsCon.name.value),
                          Text(chatsCon.email.value),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("user").doc(homeCon.senderId.value)
                          .collection("chats").doc(chatsCon.receiverId.value).collection("message")
                          .orderBy("datetime", descending: true).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
                      {
                         if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                          return ListView(
                            reverse: true,
                            children: snapshot.data!.docs.map((document) {
                              final isSender = homeCon.senderId.value == document["senderId"].toString();
                              return Align(
                                alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                  padding: EdgeInsets.all(10.0),
                                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [(document["type"] == "image") ? Image.network(document["message"].toString(), width: 200, height: 200,)
                                          : Text(document["message"].toString(), style: TextStyle(color: Colors.black),),
                                      SizedBox(height: 5.0),
                                      Text(chatsCon.getTimeDifferenceString(int.parse(document["datetime"].toString())),
                                        style: TextStyle(fontSize: 10, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSender ? Color(0xffDCF8C6) : Colors.white,
                                    borderRadius: isSender
                                        ? BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                      topRight: Radius.circular(15.0),
                                      bottomLeft: Radius.circular(15.0),
                                      bottomRight: Radius.circular(5.0),
                                    )
                                        : BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                      topRight: Radius.circular(15.0),
                                      bottomLeft: Radius.circular(5.0),
                                      bottomRight: Radius.circular(15.0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        } else {
                          return Center(child: Text("No Data"));
                        }
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              children: [
                                TextField(
                                  controller: chatsCon.messageController,
                                  scrollController: chatsCon.scrollController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Type a Message',
                                    prefixIcon: GestureDetector(
                                        onTap: () async{
                                          setState(() {
                                            chatsCon.emojiShowing.value = !chatsCon.emojiShowing.value;
                                          });
                                        },
                                        child: Icon(Icons.emoji_emotions_outlined)),
                                    suffixIcon: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.min,
                                      children:[
                                        IconButton(
                                          icon: Icon(Icons.camera_alt),
                                          onPressed: () async {
                                            final picker = ImagePicker();
                                            final XFile? photo = await picker.pickImage(source: ImageSource.camera);
                                            if (photo == null) return;
                                            setState(() {
                                              chatsCon.isLoading.value = true;
                                            });
                                            File selectedFile = File(photo.path);
                                            var id = DateTime.now().microsecondsSinceEpoch.toString();
                                            try {
                                              TaskSnapshot uploadTask = await FirebaseStorage.instance
                                                  .ref('camera/camera$id') // Folder nam  ed "images"
                                                  .putFile(selectedFile);
                                              String imageUrl = await uploadTask.ref.getDownloadURL();
                                              await FirebaseFirestore.instance
                                                  .collection("user")
                                                  .doc(homeCon.senderId.value)
                                                  .collection("chats")
                                                  .doc(chatsCon.receiverId.value)
                                                  .collection("message")
                                                  .add({
                                                "senderId": homeCon.senderId.value,
                                                "message": imageUrl,
                                                "receiverId": chatsCon.receiverId.value,
                                                "type": "image",
                                                "datetime": DateTime.now().millisecondsSinceEpoch
                                              });
                                              await FirebaseFirestore.instance
                                                  .collection("user")
                                                  .doc(chatsCon.receiverId.value)
                                                  .collection("chats")
                                                  .doc(homeCon.senderId.value)
                                                  .collection("message")
                                                  .add({
                                                "senderId": homeCon.senderId.value,
                                                "message": imageUrl,
                                                "receiverId": chatsCon.receiverId.value,
                                                "type": "image",
                                                "datetime": DateTime.now().millisecondsSinceEpoch
                                              });
                                              setState(() {
                                                chatsCon.isLoading.value = false;
                                              });
                                            } catch (error) {
                                              print("Error uploading image: $error");
                                            }
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.photo),
                                          onPressed: () async {
                                            final picker = ImagePicker();
                                            try {
                                              final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
                                              if (photo == null) return;

                                              setState(() {
                                                chatsCon.isLoading.value = true;
                                              });
                                              File selectedFile = File(photo.path);
                                              var id = DateTime.now().microsecondsSinceEpoch.toString();
                                              TaskSnapshot uploadTask = await FirebaseStorage.instance
                                                  .ref('photos$id')
                                                  .putFile(selectedFile);
                                              String imageUrl = await uploadTask.ref.getDownloadURL();
                                              await FirebaseFirestore.instance
                                                  .collection("user")
                                                  .doc(homeCon.senderId.value)
                                                  .collection("chats")
                                                  .doc(chatsCon.receiverId.value)
                                                  .collection("message")
                                                  .add({
                                                "senderId": homeCon.senderId.value,
                                                "message": imageUrl,
                                                "receiverId": chatsCon.receiverId.value,
                                                "type": "image",
                                                "datetime": DateTime.now().millisecondsSinceEpoch
                                              });

                                              await FirebaseFirestore.instance
                                                  .collection("user")
                                                  .doc(chatsCon.receiverId.value)
                                                  .collection("chats")
                                                  .doc(homeCon.senderId.value)
                                                  .collection("message")
                                                  .add({
                                                "senderId": homeCon.senderId.value,
                                                "message": imageUrl,
                                                "receiverId": chatsCon.receiverId.value,
                                                "type": "image",
                                                "datetime": DateTime.now().millisecondsSinceEpoch
                                              });

                                              setState(() {
                                                chatsCon.isLoading.value = false;
                                              });
                                            } catch (error) {
                                              print("Error uploading image: $error");
                                              setState(() {
                                                chatsCon.isLoading.value = false;
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: ()  async{
                          var message = chatsCon.messageController.text.toString();
                          if(message.length!=0)
                            {
                              chatsCon.messageController.clear();
                              chatsCon.scrollController.animateTo(
                                chatsCon.scrollController.position.minScrollExtent,
                                curve: Curves.easeInOut,
                                duration: const Duration(milliseconds: 1),
                              );
                              await FirebaseFirestore.instance.collection("user").doc(homeCon.senderId.value)
                                  .collection("chats").doc(chatsCon.receiverId.value).collection("message").add({
                                "senderId":homeCon.senderId.value,
                                "receiverId":chatsCon.receiverId.value,
                                "message":message,
                                "type":"text",
                                "datetime":DateTime.now().millisecondsSinceEpoch,
                                // "timestamp":Timestamp
                              }).then((value) async{
                                await FirebaseFirestore.instance.collection("user").doc(chatsCon.receiverId.value)
                                    .collection("chats").doc(homeCon.senderId.value).collection("message").add({
                                  "senderId":homeCon.senderId.value,
                                  "receiverId":chatsCon.receiverId.value,
                                  "message":message,
                                  "type":"text",
                                  "datetime":DateTime.now().millisecondsSinceEpoch,
                                  // "timestamp":Timestamp
                                }).then((value) async
                                {
                                  await chatsCon.api.sendPushNotification(
                                    title: homeCon.name.value,// send name
                                    body: chatsCon.name.value,// receive name
                                    to:chatsCon.token.value
                                  )!.then((value) async{
                                    if(chatsCon.isLoading.value = true) {
                                     // AppTheme.getSnackBar(message: "Send message Successfully",color:Colors.green);
                                    }
                                    else {
                                      //AppTheme.getSnackBar(message: "Send message UnSuccessfully",color: Colors.red);
                                    }
                                  });
                                }
                                );
                              });
                            }

                        },
                        color: Colors.green,
                        textColor: Colors.white,
                        child: Icon(Icons.send, size: 24),
                        padding: EdgeInsets.all(15),
                        shape: CircleBorder(),
                      ),
                      // Expanded(
                      //   child: Offstage(
                      //     offstage: !chatsCon.emojiShowing.value,
                      //     child: SizedBox(
                      //       height: 200,
                      //       child: EmojiPicker(
                      //         textEditingController: chatsCon.messageController,
                      //         scrollController: chatsCon.scrollController,
                      //         config: Config(
                      //           height: 256,
                      //           checkPlatformCompatibility: true,
                      //           swapCategoryAndBottomBar: false,
                      //           skinToneConfig: SkinToneConfig(),
                      //           categoryViewConfig: CategoryViewConfig(),
                      //           bottomActionBarConfig: BottomActionBarConfig(),
                      //           searchViewConfig: SearchViewConfig(),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              );
            })
          )
      ),
    );
  }
}
