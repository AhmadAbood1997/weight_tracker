import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/screens/login_screen.dart';

import 'add_weight_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final fb = FirebaseDatabase.instance;

  TextEditingController weightController = TextEditingController();

  var l;
  var g;
  var k;
  @override
  Widget build(BuildContext context) {
    final ref = fb.ref().child('weight_tracker');

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo[900],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddWeight(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Weight Traker',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ),
        backgroundColor: Colors.indigo[900],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FirebaseAnimatedList(
              query: ref,
              shrinkWrap: true,
              itemBuilder: (context, snapshot, animation, index) {
                var v = snapshot.value
                    .toString(); // {subtitle: webfun, title: subscribe}

                g = v.replaceAll(RegExp("{|}|subtitle:|title:|"), "");

                // webfun, subscribe
                l = g.split(','); // [webfun
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      k = snapshot.key;
                    });
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Container(
                          decoration: BoxDecoration(border: Border.all()),
                          child: TextField(
                            controller: weightController,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: 'Enter your weight',
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          MaterialButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            color: const Color.fromARGB(255, 0, 22, 145),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              await upd();
                              Navigator.of(ctx).pop();
                            },
                            color: const Color.fromARGB(255, 0, 22, 145),
                            child: const Text(
                              "Update",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      tileColor: Colors.indigo[100],
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Color.fromARGB(255, 255, 0, 0),
                        ),
                        onPressed: () {
                          ref.child(snapshot.key!).remove();
                        },
                      ),
                      title: Text(
                        l[1].toString(),
                        // 'dd',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        l[0].toString(),
                        // 'dd',

                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Center(
                child: ElevatedButton(
              child: const Text("Logout"),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return const LoginScreen();
                  }));
                });
              },
            )),
          ],
        ),
      ),
    );
  }

  upd() async {
    DatabaseReference ref1 = FirebaseDatabase.instance.ref("weight_tracker/$k");

// Only update the name, leave the age and address!
    await ref1.update({
      "weight": weightController.text,
    });
    weightController.clear();
  }
}
