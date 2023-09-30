import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chatapp/HomeScreen.dart';
import 'package:flutter/material.dart';

class NotificationExample extends StatefulWidget {
  const NotificationExample({Key? key}) : super(key: key);

  @override
  State<NotificationExample> createState() => _NotificationExampleState();
}

class _NotificationExampleState extends State<NotificationExample> {



  @override
  Widget build(BuildContext context) {
    AwesomeNotifications().actionStream.listen((receivedNotification) {
      // prints the key of the NotificationActionButton pressed
      if(receivedNotification.buttonKeyPressed=="home")
      {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>HomeScreen())
        );
      }
      else if (receivedNotification.buttonKeyPressed=="about")
        {

        }
    });
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    AwesomeNotifications().createNotification(
                        content: NotificationContent(
                            id: 10,
                            channelKey: 'alerts',
                            title: 'Warning!',
                            body: 'Welcome to my Chat App',
                        )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                  ),
                  child: Text("Local Notification"),
                ),
                ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                  ),
                  child: Text("Cloud"),
                ),
              ],
            ),
            SizedBox(height: 50.0),
            ElevatedButton(
              onPressed: () async{

                bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
                if(isAllowed)
                  {
                    AwesomeNotifications().createNotification(
                      content: NotificationContent(
                        id: 10,
                        channelKey: 'alerts',
                        title: 'Warning!',
                        body: 'Welcome to my Chat App',
                      ),
                      actionButtons: [
                        NotificationActionButton(key: 'home', label: 'Home'),
                        NotificationActionButton(key: 'about', label: 'About'),
                      ],
                    );
                  }
                else
                  {
                    showDialog(context: context, builder: (context){
                      return AlertDialog(
                        title: Text('Get Notified!', style: Theme.of(context).textTheme.titleLarge),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                             SizedBox(height: 20),
                             Text('Allow Awesome Notifications to send you beautiful notifications!'),
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Deny',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(color: Colors.red),
                              )),
                          TextButton(
                              onPressed: () async {
                                await AwesomeNotifications().requestPermissionToSendNotifications();
                              },
                              child: Text('Allow',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(color: Colors.deepPurple),
                              )),
                        ],
                      );
                    });
                  }
                // AwesomeNotifications().createNotification(
                //   content: NotificationContent(
                //     id: 1234,
                //     channelKey: 'img',
                //     title: 'Hello! How are you?',
                //     body: 'This is a simple notification',
                //     bigPicture: 'asset://img/notification.jpg',
                //     notificationLayout: NotificationLayout.BigPicture,
                //   ),
                // );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
              ),
              child: Text("Show Notification Button"),
            ),
            ElevatedButton(
              onPressed: () {
                AwesomeNotifications().createNotification(
                    content: NotificationContent( //with image from URL
                      id: 12345,
                      channelKey: 'image',
                      title: 'Simple Notification with Network Image',
                      body: 'This simple notification is from Flutter App',
                      bigPicture: 'https://www.fluttercampus.com/img/logo_small.webp',
                      notificationLayout: NotificationLayout.BigPicture,
                    )
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
              ),
              child: Text("Show Notification Network "),
            ),
          ],
        ),
      ),
    );
  }
}
