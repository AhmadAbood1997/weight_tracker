import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weight_tracker/screens/home_screen.dart';

class AddWeight extends StatefulWidget {
  const AddWeight({Key? key}) : super(key: key);

  @override
  AddWeightState createState() => AddWeightState();
}

class AddWeightState extends State<AddWeight> {
  TextEditingController weight = TextEditingController();

  final fb = FirebaseDatabase.instance;
  @override
  Widget build(BuildContext context) {
    var rng = Random();
    var k = rng.nextInt(10000);

    final ref = fb.ref().child('weight_tracker/$k');

    var now = DateTime.now();
    var formatter = DateFormat.yMd().add_jm();
    String formattedDate = formatter.format(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Weights"),
        backgroundColor: Colors.indigo[900],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(border: Border.all()),
            child: TextField(
              controller: weight,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: 'Enter your weight',
                  contentPadding: EdgeInsets.all(10)),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          MaterialButton(
            color: Colors.indigo[900],
            onPressed: () {
              ref.set({
                "weight": weight.text,
                "date": formattedDate.toString()
              }).asStream();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()));
            },
            child: const Text(
              "save",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
