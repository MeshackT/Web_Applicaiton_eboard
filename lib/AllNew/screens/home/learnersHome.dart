import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';

import '../Authentication/Authenticate.dart';

//get current logged in user
User? user = FirebaseAuth.instance.currentUser;
Logger logger = Logger(printer: PrettyPrinter(colors: true));
final CollectionReference learnersRef =
    FirebaseFirestore.instance.collection('learnersData');

class LearnerHome extends StatefulWidget {
  const LearnerHome({Key? key}) : super(key: key);

  @override
  State<LearnerHome> createState() => _LearnerHomeState();
}

class _LearnerHomeState extends State<LearnerHome> {
  List<String> fieldArray = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DocumentSnapshot> documents = [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text("My Marks"),
        actions: [
          IconButton(
            onPressed: () {
              sigOut(context);
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
        ],
      ),
      extendBody: true,
      drawer: DoubleBackToCloseApp(
        snackBar: SnackBar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(1),
          content: Text(
            'Tap back again to leave the application',
            style: TextStyle(color: Theme.of(context).primaryColorLight),
            textAlign: TextAlign.center,
          ),
        ),
        child: SafeArea(
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              children: [
                buildHeader(context),
                Expanded(
                  flex: 1,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: learnersRef
                        .where('uid', isEqualTo: user!.uid)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Column(
                            children: [
                              const Text("Waiting for the internet connection"),
                              SpinKitChasingDots(
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        );
                      }

                      final List<QueryDocumentSnapshot> matchingDocs =
                          snapshot.data!.docs;
                      if (matchingDocs.isEmpty) {
                        return const Center(
                          child: Text('No matching documents found.'),
                        );
                      }

                      final DocumentSnapshot matchingDoc = matchingDocs.first;
                      final List<dynamic> subjectsList =
                          matchingDoc['subjects'];

                      return ListView.builder(
                        itemCount: subjectsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String subject = subjectsList[index];
                          return ListTile(
                            title: Text(
                              subject,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 0.0),
        decoration: const BoxDecoration(
          //screen background color
          gradient: LinearGradient(
              colors: [Color(0x0fffffff), Color(0xE7791971)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: Column(
          children: [
            Text(""),
            Text("data"),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
            topLeft: Radius.circular(150),
            topRight: Radius.circular(150),
          ),
          child: Container(
            color: Theme.of(context).primaryColor.withOpacity(.40),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  child: Text(
                    user!.email.toString()[0].toUpperCase(),
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                Text(
                  user!.displayName.toString(),
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.purple),
                ),
                const SizedBox(
                  height: 22,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 22,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            user!.email.toString().toUpperCase(),
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor),
          ),
        ),
        const SizedBox(
          height: 22,
        ),
      ],
    );
  }

  Future sigOut(BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: SpinKitChasingDots(
                color: Theme.of(context).primaryColor,
              ),
            );
          });
      await FirebaseAuth.instance
          .signOut()
          .then((value) => SpinKitChasingDots(
                color: Theme.of(context).primaryColor,
              ))
          .whenComplete(
            () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Authenticate())),
          );
    } catch (e) {
      logger.i(e.toString());
    }
  }
}
