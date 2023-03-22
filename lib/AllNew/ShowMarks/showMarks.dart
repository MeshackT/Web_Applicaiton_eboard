import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ShowMarks extends StatefulWidget {
  const ShowMarks({Key? key}) : super(key: key);

  @override
  State<ShowMarks> createState() => _ShowMarksState();
}

class _ShowMarksState extends State<ShowMarks> {
  //current user logged in
  User? userId = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('learnersData')
            .doc(userId.toString())
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SpinKitChasingDots(
                color: Theme.of(context).primaryColor,
              ),
            );
          }

          final List<dynamic> myArray =
              snapshot.data![(userId!.uid).toString()];

          return ListView.builder(
            itemCount: myArray.length,
            itemBuilder: (BuildContext context, int index) {
              final String item = myArray[index];
              return Text(item);
            },
          );
        },
      ),
    );
  }
}
