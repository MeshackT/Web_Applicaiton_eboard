import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../home/home.dart';

class Grade11 extends StatefulWidget {
  const Grade11({Key? key}) : super(key: key);

  @override
  State<Grade11> createState() => _Grade11State();
}

class _Grade11State extends State<Grade11> {
  TextEditingController search = TextEditingController();

  //make an if statement to chech which user logged in and stream data accordingly
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('learnersData')
      .where("subject1", isEqualTo: "Mathematics")
      .where("grade", isEqualTo: "11")
      .snapshots();

  String uid = "";
  String name = "";
  String grade = "";
  String subject1 = "";
  String documentID = "";
  String learnersDocumentID = "";
  String term1Mark1 = "";
  String term1Mark2 = "";
  String term1Mark3 = "";
  String term1Mark4 = "";
  String term1Assignment1 = "";
  String term1Assignment2 = "";
  String term1Assignment3 = "";
  String term1Assignment4 = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register learner"),
        elevation: 0.0,
        centerTitle: true,
      ),
      drawer: const NavigationDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(fontSize: 14.0, color: Colors.red),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
                backgroundColor: Colors.green,
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.size,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot data = snapshot.data!.docs[index];
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    const Text("A list of grade 11 Mathematics learners"),
                    ListTile(
                      title: Row(
                        children: [
                          Text(
                            data['name'],
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Grade " + data['grade'],
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: const Icon(
                                Icons.undo,
                                size: 20,
                                color: Colors.grey,
                              ),
                              onPressed: () async {
                                try {
                                  name = data['name'];
                                  subject1 = data['subject1'];
                                  grade = data['grade'];

                                  addRequest(
                                    name,
                                    documentID,
                                    grade,
                                    subject1,
                                    term1Assignment1,
                                    term1Assignment2,
                                    term1Assignment3,
                                    term1Assignment4,
                                    term1Mark1,
                                    term1Mark2,
                                    term1Mark3,
                                    term1Mark4,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Request added '),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Request failed to archive'),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

//////////////////////////////////////////
//     put data in the database         //
// ///////////////////////////////////////

  Future<void> addRequest(
    String name,
    String documentID,
    String grade,
    String subject1,
    String term1Assignment1,
    String term1Assignment2,
    String term1Assignment3,
    String term1Assignment4,
    String term1Mark1,
    String term1Mark2,
    String term1Mark3,
    String term1Mark4,
  ) {
    User? user = FirebaseAuth.instance.currentUser;
    final learnersData =
        FirebaseFirestore.instance.collection('Grade12MathematicsData').doc();

    final documentID = learnersData.id;

    return learnersData
        .set({
          'name': name,
          'subject': subject1,
          'grade': grade,
          'uid': user!.uid,
          'documentID': documentID,
          'term1Mark1': term1Mark1,
          'term1Mark2': term1Mark2,
          'term1Mark3': term1Mark3,
          'term1Mark4': term1Mark4,
          'term1Assignment1': term1Assignment1,
          'term1Assignment2': term1Assignment2,
          'term1Assignment3': term1Assignment3,
          'term1Assignment4': term1Assignment4,
        })
        .then(
          (value) => Fluttertoast.showToast(msg: "Successfully Added Learner")
          // .whenComplete(() =>
          //     Navigator.pushNamedAndRemoveUntil(
          // context, MyRequest.routeName, (route) => false))
          ,
        )
        .catchError(
          (error) =>
              Fluttertoast.showToast(msg: "failed to add details $error"),
        );
  }
}
