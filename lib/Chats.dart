import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chats extends StatefulWidget {
  var name="";
  var email="";
  var photo="";
  var receiverid="";
  Chats({required this.name, required this.email,required this.photo,required this.receiverid});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  
  TextEditingController _message = TextEditingController();

  final _focusNode = FocusNode();
  var emojiShowing = false;
  final ImagePicker picker = ImagePicker();
  File? selectedfile;
  var senderid="";

  var isloading=false;

  getdata() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      senderid = prefs.getString("senderid").toString();
    });
  }
  ScrollController _scrollController = new ScrollController();
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
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.photo),
                    radius: 20,
                  ),
                  SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name.toString()),
                      Text(widget.email.toString()),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     IconButton(
                  //       icon: Icon(Icons.video_camera_front_outlined),
                  //       onPressed: (){},
                  //     ),
                  //     IconButton(
                  //       icon: Icon(Icons.call),
                  //       onPressed: (){},
                  //     ),
                  //     PopupMenuButton<String>(
                  //       onSelected: (val) {
                  //       },
                  //       itemBuilder: (BuildContext bc) {
                  //         return <PopupMenuEntry<String>>[
                  //           PopupMenuItem(
                  //             child: Text("Group Info"),
                  //             value: 'group_info',
                  //           ),
                  //           PopupMenuItem(
                  //             child: Text("Group Media"),
                  //             value: 'group_media',
                  //           ),
                  //           PopupMenuItem(
                  //             child: Text("Search"),
                  //             value: 'search',
                  //           ),
                  //           PopupMenuItem(
                  //             child: Text("Wallpaper"),
                  //             value: 'wallpaper',
                  //           ),
                  //           PopupMenuItem(
                  //             child: Text("More"),
                  //             value: 'more',
                  //           ),
                  //         ];
                  //       },
                  //     )
                  //   ],
                  // ),
                ],
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("user").doc(senderid)
                      .collection("chats").doc(widget.receiverid).collection("message").orderBy("datetime",descending: true).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
                  {
                    if(snapshot.hasData)
                      {
                        if(snapshot.data!.size <=0)
                          {
                            return Center(
                              child: Text("No messages"),
                            );
                          }
                        else
                          {
                            return ListView(
                              controller: _scrollController,
                              reverse: true,
                              children: snapshot.data!.docs.map((document){
                                if(senderid == document["senderid"].toString())
                                  {
                                    return Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        margin: EdgeInsets.all(10.0),
                                        padding: EdgeInsets.all(10.0),
                                        child: (document["type"]=="image")?Image.network(document["message"].toString(),width: 120.0,):Text(document["message"].toString(),style: TextStyle(color: Colors.white),),
                                        decoration: BoxDecoration(
                                            color: Color(0xff20A090),
                                          borderRadius: BorderRadius.circular(15.0)
                                        ),
                                      ),
                                    );
                                  }
                                else
                                  {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        margin: EdgeInsets.all(10.0),
                                        padding: EdgeInsets.all(10.0),
                                        child:  (document["type"]=="image")?Image.network(document["message"].toString(),width: 120.0,):Text(document["message"].toString(),style: TextStyle(color: Colors.white),),
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(10.0)
                                        ),
                                      ),
                                    );
                                  }
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
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          children: [
                            TextField(
                              onTap: (){
                                setState(() {
                                  emojiShowing = false;
                                });
                              },
                              controller: _message,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Type a Message',
                                prefixIcon: GestureDetector(
                                    onTap: () async{
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      setState(() {
                                        emojiShowing = !emojiShowing;
                                      });
                                    },
                                    child: Icon(Icons.emoji_emotions_outlined)),
                                suffixIcon: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children:[
                                    IconButton(
                                      icon: Icon(Icons.camera_alt),
                                      onPressed: () async{
                                        final XFile? photo = await picker.pickImage(source: ImageSource.camera);
                                        if(photo!=null) {
                                          setState(() {
                                            isloading = true;
                                          });
                                          var uuid = Uuid();
                                          var filename = uuid.v4();
                                          File selectedfile = File(photo!.path);
                                          await FirebaseStorage.instance.ref(filename)
                                              .putFile(selectedfile)
                                              .whenComplete((){})
                                              .then((filedata) async {
                                            await filedata.ref.getDownloadURL().then((fileurl) async {
                                              await FirebaseFirestore.instance.collection("user").doc(senderid)
                                                  .collection("chats").doc(widget.receiverid)
                                                  .collection("message")
                                                  .add({
                                                "senderid": senderid,
                                                "message": fileurl,
                                                "receiverid": widget.receiverid,
                                                "type": "image",
                                                "datetime": DateTime
                                                    .now()
                                                    .millisecondsSinceEpoch
                                              })
                                                  .then((value) async {
                                                await FirebaseFirestore.instance.collection("user").doc(
                                                    widget.receiverid)
                                                    .collection("chats").doc(senderid).collection("message").add({
                                                  "senderid": senderid,
                                                  "message": fileurl,
                                                  "receiverid": widget.receiverid,
                                                  "type": "image",
                                                  "datetime": DateTime
                                                      .now()
                                                      .millisecondsSinceEpoch
                                                }).then((value) {
                                                  AwesomeNotifications().createNotification(
                                                    content: NotificationContent(
                                                      id: 12345,
                                                      channelKey: 'image',
                                                      title: 'Simple Notification with Network Image',
                                                      body: 'This simple notification is from Flutter App',
                                                      bigPicture: fileurl,
                                                      notificationLayout: NotificationLayout.BigPicture,
                                                    ),
                                                    actionButtons: [
                                                      NotificationActionButton(key: 'home', label: 'Home'),
                                                      NotificationActionButton(key: 'about', label: 'About'),
                                                    ],
                                                  );
                                                  setState(() {
                                                    isloading = false;
                                                  });
                                                });
                                              });
                                            });
                                          });
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.photo),
                                      onPressed: () async{
                                        final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
                                        if(photo!=null)
                                        {
                                          setState(() {
                                            isloading=true;
                                          });
                                          var uuid = Uuid();
                                          var filename = uuid.v4();
                                          File selectedfile = File(photo!.path);
                                          await FirebaseStorage.instance.ref(filename).putFile(selectedfile).whenComplete((){}).then((filedata) async{
                                            await filedata.ref.getDownloadURL().then((fileurl)async{
                                              await FirebaseFirestore.instance.collection("user").doc(senderid)
                                                  .collection("chats").doc(widget.receiverid).collection("message").add({
                                                "senderid":senderid,
                                                "message":fileurl,
                                                "receiverid":widget.receiverid,
                                                "type":"image",
                                                "datetime":DateTime.now().millisecondsSinceEpoch
                                              }).then((value) async{
                                                await FirebaseFirestore.instance.collection("user").doc(widget.receiverid)
                                                    .collection("chats").doc(senderid).collection("message").add({
                                                  "senderid":senderid,
                                                  "message":fileurl,
                                                  "receiverid":widget.receiverid,
                                                  "type":"image",
                                                  "datetime":DateTime.now().millisecondsSinceEpoch
                                                }).then((value){
                                                  // Local Notification
                                                  AwesomeNotifications().createNotification(
                                                      content: NotificationContent(
                                                        id: 12345,
                                                        channelKey: 'image',
                                                        title: 'Simple Notification with Network Image',
                                                        body: 'This simple notification is from Flutter App',
                                                        bigPicture: fileurl,
                                                        notificationLayout: NotificationLayout.BigPicture,
                                                      ),
                                                      actionButtons: [
                                                        NotificationActionButton(key: 'home', label: 'Home'),
                                                        NotificationActionButton(key: 'about', label: 'About'),
                                                      ],
                                                  );
                                                  setState(() {
                                                    isloading=false;
                                                  });
                                                });
                                              });
                                            });
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              //),
                                // suffixIcon: Center(
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     mainAxisSize: MainAxisSize.min,
                                //     children: [
                                //       Spacer(),
                                //       GestureDetector(
                                //         onTap: () async{
                                //           final XFile? photo = await picker.pickImage(source: ImageSource.camera);
                                //           if(photo!=null) {
                                //             setState(() {
                                //               isloading = true;
                                //             });
                                //             var uuid = Uuid();
                                //             var filename = uuid.v4();
                                //             File selectedfile = File(photo!.path);
                                //             await FirebaseStorage.instance.ref(filename)
                                //                 .putFile(selectedfile)
                                //                 .whenComplete((){})
                                //                 .then((filedata) async {
                                //               await filedata.ref.getDownloadURL().then((fileurl) async {
                                //                 await FirebaseFirestore.instance.collection("user").doc(senderid)
                                //                     .collection("chats").doc(widget.receiverid)
                                //                     .collection("message")
                                //                     .add({
                                //                   "senderid": senderid,
                                //                   "message": fileurl,
                                //                   "receiverid": widget.receiverid,
                                //                   "type": "image",
                                //                   "datetime": DateTime
                                //                       .now()
                                //                       .millisecondsSinceEpoch
                                //                 })
                                //                     .then((value) async {
                                //                   await FirebaseFirestore.instance.collection("user").doc(
                                //                       widget.receiverid)
                                //                       .collection("chats").doc(senderid).collection("message").add({
                                //                     "senderid": senderid,
                                //                     "message": fileurl,
                                //                     "receiverid": widget.receiverid,
                                //                     "type": "image",
                                //                     "datetime": DateTime
                                //                         .now()
                                //                         .millisecondsSinceEpoch
                                //                   }).then((value) {
                                //                     setState(() {
                                //                       isloading = false;
                                //                     });
                                //                   });
                                //                 });
                                //               });
                                //             });
                                //           }
                                //         },
                                //         child: Icon(Icons.camera_alt),
                                //       ),
                                //       SizedBox(width:20.0),
                                //       GestureDetector(
                                //           onTap: () async{
                                //             final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
                                //             if(photo!=null)
                                //             {
                                //               setState(() {
                                //                 isloading=true;
                                //               });
                                //               var uuid = Uuid();
                                //               var filename = uuid.v4();
                                //               File selectedfile = File(photo!.path);
                                //               await FirebaseStorage.instance.ref(filename).putFile(selectedfile).whenComplete((){}).then((filedata) async{
                                //                 await filedata.ref.getDownloadURL().then((fileurl)async{
                                //                   await FirebaseFirestore.instance.collection("user").doc(senderid)
                                //                       .collection("chats").doc(widget.receiverid).collection("message").add({
                                //                     "senderid":senderid,
                                //                     "message":fileurl,
                                //                     "receiverid":widget.receiverid,
                                //                     "type":"image",
                                //                     "datetime":DateTime.now().millisecondsSinceEpoch
                                //                   }).then((value) async{
                                //                     await FirebaseFirestore.instance.collection("user").doc(widget.receiverid)
                                //                         .collection("chats").doc(senderid).collection("message").add({
                                //                       "senderid":senderid,
                                //                       "message":fileurl,
                                //                       "receiverid":widget.receiverid,
                                //                       "type":"image",
                                //                       "datetime":DateTime.now().millisecondsSinceEpoch
                                //                     }).then((value){
                                //                       setState(() {
                                //                         isloading=false;
                                //                       });
                                //                     });
                                //                   });
                                //                 });
                                //               });
                                //             }
                                //           },
                                //           child: Icon(Icons.photo))
                                //     ],
                                //   ),
                                // ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  (isloading)?CircularProgressIndicator():MaterialButton(
                    onPressed: ()  async{
                      var msg = _message.text.toString();
                      if(msg.length!=0)
                        {
                          _message.text="";
                          _scrollController.animateTo(_scrollController.position.minScrollExtent,
                            curve: Curves.easeInOut,
                            duration: const Duration(milliseconds: 1),
                          );
                          await FirebaseFirestore.instance.collection("user").doc(senderid)
                              .collection("chats").doc(widget.receiverid).collection("message").add({
                            "senderid":senderid,
                            "message":msg,
                            "receiverid":widget.receiverid,
                            "type":"text",
                            "datetime":DateTime.now().millisecondsSinceEpoch
                          }).then((value) async{

                            await FirebaseFirestore.instance.collection("user").doc(widget.receiverid)
                                .collection("chats").doc(senderid).collection("message").add({
                              "senderid":senderid,
                              "message":msg,
                              "receiverid":widget.receiverid,
                              "type":"text",
                              "datetime":DateTime.now().millisecondsSinceEpoch
                            }).then((value){
                            });
                          });
                        }
                    },
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Icon(Icons.send, size: 24),
                    padding: EdgeInsets.all(15),
                    shape: CircleBorder(),
                  )
                ],
              ),
              Offstage(
                offstage: !emojiShowing,
                child: SizedBox(
                    height: 250,
                    child: EmojiPicker(
                      textEditingController: _message,
                      config: Config(
                        columns: 7,
                        emojiSizeMax: 32 * 1.0,
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        gridPadding: EdgeInsets.zero,
                        initCategory: Category.RECENT,
                        bgColor: const Color(0xFFF2F2F2),
                        indicatorColor: Colors.blue,
                        iconColor: Colors.grey,
                        iconColorSelected: Colors.blue,
                        backspaceColor: Colors.blue,
                        skinToneDialogBgColor: Colors.white,
                        skinToneIndicatorColor: Colors.grey,
                        enableSkinTones: true,
                        recentTabBehavior: RecentTabBehavior.RECENT,
                        recentsLimit: 28,
                        replaceEmojiOnLimitExceed: false,
                        noRecents: const Text('No Recents',
                          style: TextStyle(fontSize: 20, color: Colors.black26),
                          textAlign: TextAlign.center,
                        ),
                        loadingIndicator: const SizedBox.shrink(),
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: const CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL,
                        checkPlatformCompatibility: true,
                      ),
                    )),
              ),
            ],
          ),
        )
      ),
    );
  }
}
