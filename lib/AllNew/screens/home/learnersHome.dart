import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';

import '../Authentication/Authenticate.dart';

//get current logged in user
User? user = FirebaseAuth.instance.currentUser;
Logger logger = Logger(printer: PrettyPrinter(colors: true));

class LearnerHome extends StatefulWidget {
  const LearnerHome({Key? key}) : super(key: key);

  @override
  State<LearnerHome> createState() => _LearnerHomeState();
}

class _LearnerHomeState extends State<LearnerHome> {
  List<String> fieldArray = [];

  Future<void> getFieldArray() async {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('learnersData');

    final QuerySnapshot snapshot =
        await usersCollection.where('uid', isEqualTo: user!.uid).get();

    final DocumentSnapshot documentSnapshot = snapshot.docs.first;

    setState(() {
      fieldArray = List<String>.from(documentSnapshot.get('subjects'));
      print(fieldArray);
    });
    print(fieldArray);
  }

  @override
  void initState() {
    super.initState();
    getFieldArray();
  }

  @override
  Widget build(BuildContext context) {
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
      drawer: SafeArea(
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            children: [
              buildHeader(context),
              Expanded(
                  flex: 1,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('learnersData')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (!snapshot.hasData) {
                        return Center(
                          child: SpinKitChasingDots(
                            color: Theme.of(context).primaryColor,
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: Column(
                          children: [
                            Text(
                              'Waiting for Internet Connection',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple.shade600,
                              ),
                            ),
                            SpinKitChasingDots(
                              color: Theme.of(context).primaryColorDark,
                              size: 15,
                            ),
                          ],
                        ));
                      } else if (snapshot.connectionState ==
                          ConnectionState.none) {
                        return Center(
                            child: Column(
                          children: [
                            Text(
                              'No for Internet Connection',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple.shade600,
                              ),
                            ),
                            SpinKitChasingDots(
                              color: Theme.of(context).primaryColorDark,
                              size: 15,
                            ),
                          ],
                        ));
                      }

                      final documents = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          final myArray =
                              documents[index]['subjects'] as List<dynamic>;

                          return Card(
                            child: Column(
                              children: [
                                for (var item in myArray) ...[
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(150),
                                      bottomRight: Radius.circular(0),
                                      topLeft: Radius.circular(150),
                                    ),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Container(
                                        color: Theme.of(context).primaryColor,
                                        child: ListTile(
                                          title: Text(
                                            item,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColorLight),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ]
                              ],
                            ),
                          );
                        },
                      );
                    },
                  )),
            ],
          ),
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
            color: Colors.purple.shade100,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  child: Text((user!.email.toString()[0].toUpperCase()) ?? ""),
                ),
                const SizedBox(
                  height: 22,
                ),
                Text(
                  (user!.email.toString().substring(0, 5).toUpperCase() ?? ""),
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
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.purple),
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
