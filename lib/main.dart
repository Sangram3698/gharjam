import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
//import 'package:gharjam/screen/ask.dart';
import 'package:gharjam/screen/help.dart';
import 'package:gharjam/screen/home.dart';
import 'package:gharjam/screen/search.dart';
import 'package:gharjam/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings("@mipmap/ic_launcher");

  DarwinInitializationSettings iosSetting = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true);

  InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings, iOS: iosSetting);
  bool? initialized =
      await notificationsPlugin.initialize(initializationSettings);
  log("Notification: $initialized");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

int _currentState = 0;

final List<Widget> _children = [Home(), Search(), Ask(), Help()];

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((message) {
      log("received");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message.notification!.body.toString()),
        duration: Duration(seconds: 10),
        backgroundColor: Colors.blue,
      ));
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("App was opened by this message"),
        duration: Duration(seconds: 8),
        backgroundColor: Colors.red,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 231, 226, 226),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Center(
          child: Text(
            "GharJam",
            style: TextStyle(
                fontSize: 21.0,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic),
          ),
        ),
      ),
      body: _children[_currentState],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentState,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.orange,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Search',
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            label: 'Ask',
            icon: Icon(Icons.question_mark),
          ),
          BottomNavigationBarItem(
            label: 'Heart',
            icon: Icon(Icons.heart_broken_rounded),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentState = index;
          });
        },
      ),
    );
  }
}

class Ask extends StatefulWidget {
  const Ask({super.key});

  @override
  State<Ask> createState() => _AskState();
}

class _AskState extends State<Ask> {
  var askCont = TextEditingController();

  void saveQuery() async {
    var ask = askCont.text.toString().trim();

    askCont.clear();
    if (ask == "") {
      log("Please type  something");
    } else {
      Map<String, dynamic> userData = {"ask": ask};
      FirebaseFirestore.instance.collection("asking").add(userData);
      log("Query Saved");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  void showNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            "notification-youtube", "Youtube Notification",
            priority: Priority.max, importance: Importance.max);
    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);
    NotificationDetails notDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    await notificationsPlugin.show(
        0, "Ghar Jam Notice", "There is a new post in Ghar Jam", notDetails);
    log("Notification above");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 254, 173, 52),
      content: Container(
        height: 200,
        color: Color.fromARGB(255, 254, 173, 52),
        child: Column(
          children: [
            SizedBox(
              height: 22,
            ),
            TextField(
              controller: askCont,
              decoration: InputDecoration(
                label: Text(
                  "Ask Something",
                  style: TextStyle(
                      fontSize: 21.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            MaterialButton(
              color: Colors.blue,
              onPressed: () {
                saveQuery();
                showNotification();
              },
              child: const Text(
                "Ask",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
