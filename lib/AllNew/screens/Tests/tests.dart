import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../home/selectTodDo.dart';

class AddMarks {
  final String mark1;
  final String mark2;
  final String mark3;
  final String mark4;

  AddMarks(this.mark1, this.mark2, this.mark3, this.mark4);

  CollectionReference marks = FirebaseFirestore.instance.collection('marks');

  Future<void> addMarks() {
    // Call the user's CollectionReference to add a new user
    return marks
        .add({
          'mark1': mark1, // John Doe
          'mark2': mark2, // Stokes and Sons
          'mark3': mark3, // 42
          'mark4': mark4 // 42
        })
        .then((value) => print("User marks"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}

class TestsMarks extends StatefulWidget {
  const TestsMarks({Key? key}) : super(key: key);

  @override
  State<TestsMarks> createState() => _TestsMarksState();
}

class _TestsMarksState extends State<TestsMarks> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController testMark1 = TextEditingController();
  TextEditingController testMark2 = TextEditingController();
  TextEditingController testMark3 = TextEditingController();
  TextEditingController testMark4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                navigate(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ],
        ),
        title: const Text("Test Marks"),
        titleSpacing: 2,
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(80),
              topLeft: Radius.circular(80),
            ),
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              color: Colors.purple.shade100,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      "Test Marks",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.purple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      decoration: const InputDecoration().copyWith(
                          label: const Text("Mark 1"),
                          hintText: "90",
                          filled: true,
                          fillColor: Colors.white),
                      controller: testMark1,
                      keyboardType: const TextInputType.numberWithOptions(),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "No mark entered else enter zero";
                        } else if (val.length > 100) {
                          return "Enter a number from 0 to 100";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          testMark1.text = val;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration().copyWith(
                          filled: true,
                          fillColor: Colors.white,
                          label: const Text("Mark 2"),
                          hintText: "90"),
                      controller: testMark2,
                      keyboardType: const TextInputType.numberWithOptions(),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "No mark entered else enter zero";
                        } else if (val.length > 100) {
                          return "Enter a number from 0 to 100";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          testMark2.text = val;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration().copyWith(
                        filled: true,
                        fillColor: Colors.white,
                        label: const Text("Mark 3"),
                        hintText: "90",
                      ),
                      controller: testMark3,
                      keyboardType: const TextInputType.numberWithOptions(),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "No mark entered else enter zero";
                        } else if (val.length > 100) {
                          return "Enter a number from 0 to 100";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          testMark3.text = val;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration().copyWith(
                          filled: true,
                          fillColor: Colors.white,
                          label: const Text("Mark 4"),
                          hintText: "90"),
                      controller: testMark4,
                      keyboardType: const TextInputType.numberWithOptions(),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "No mark entered else enter zero";
                        } else if (val.length > 100) {
                          return "Enter a number from 0 to 100";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          testMark4.text = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        //check if the form is validated
                        if (_formKey.currentState!.validate()) {
                          AddMarks marks = AddMarks(testMark1.text,
                              testMark2.text, testMark3.text, testMark4.text);
                          marks.addMarks();
                        } else {
                          if (kDebugMode) {
                            print("insert data as required");
                          }
                          // Utils.showSnackBar("Enter log in details");
                          setState(() {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Enter details'),
                              duration: const Duration(seconds: 1),
                              action: SnackBarAction(
                                label: 'ACTION',
                                onPressed: () {},
                              ),
                            ));
                          });
                        }
                      },
                      color: Colors.purple,
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//Navigate to the previous page
Future navigate(BuildContext context) {
  return Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => const Select(),
    ),
  );
}
