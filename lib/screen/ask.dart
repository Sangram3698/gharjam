import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gharjam/main.dart';

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
