import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:levy/AllNew/screens/Authentication/LearnerAuthentication/EditSubjects.dart';
import 'package:levy/AllNew/screens/home/learnerViewMarks.dart';
import 'package:levy/AllNew/shared/constants.dart';
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
  bool loading = false;

  ///TODO Term One//
  String termOneTestOneMark = "";
  String termOneTestTwoMark = "";
  String termOneTestThreeMark = "";
  String termOneTestFourMark = "";

  String termOneAssignmentOneMark = "";
  String termOneAssignmentTwoMark = "";
  String termOneAssignmentThreeMark = "";
  String termOneAssignmentFourMark = "";

  String termOneExamOneMark = "";
  String termOneExamTwoMark = "";

  ///TODO Term Two//
  String termTwoTestOneMark = "";
  String termTwoTestTwoMark = "";
  String termTwoTestThreeMark = "";
  String termTwoTestFourMark = "";

  String termTwoAssignmentOneMark = "";
  String termTwoAssignmentTwoMark = "";
  String termTwoAssignmentThreeMark = "";
  String termTwoAssignmentFourMark = "";

  String termTwoExamOneMark = "";
  String termTwoExamTwoMark = "";

  ///TODO end of term 2///
  ///TODO Term One//
  String termThreeTestOneMark = "";
  String termThreeTestTwoMark = "";
  String termThreeTestThreeMark = "";
  String termThreeTestFourMark = "";

  String termThreeAssignmentOneMark = "";
  String termThreeAssignmentTwoMark = "";
  String termThreeAssignmentThreeMark = "";
  String termThreeAssignmentFourMark = "";

  String termThreeExamOneMark = "";
  String termThreeExamTwoMark = "";

  ///TODO Term Four//
  String termFourTestOneMark = "";
  String termFourTestTwoMark = "";
  String termFourTestThreeMark = "";
  String termFourTestFourMark = "";

  String termFourAssignmentOneMark = "";
  String termFourAssignmentTwoMark = "";
  String termFourAssignmentThreeMark = "";
  String termFourAssignmentFourMark = "";

  String termFourExamOneMark = "";
  String termFourExamTwoMark = "";

  ///TODO end of term 4///
  ///
  String _userSubject = '';

  @override
  void initState() {
    super.initState();
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
                      final List<dynamic> subjectsMarksList =
                          matchingDoc['allSubjects'];

                      return ListView.builder(
                        itemCount: subjectsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String subject = subjectsList[index];
                          return ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(100),
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(100),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: InkWell(
                                onTap: () async {
                                  // logger.i(subjectsMarksList);
                                  setState(() {
                                    loading = true;
                                  });
                                  ////////////All Marks////////

                                  try {
                                    //check if the document is not empty and get the data
                                    if (subjectsMarksList != null) {
                                      //go to the field in the document
                                      //check if the data is a List
                                      if (subjectsMarksList is List) {
                                        bool foundCatIndex = false;
                                        //for every item in the list
                                        for (var item in subjectsMarksList) {
                                          //if the item is==$userSubject
                                          if (item.containsKey(
                                              subjectsList[index])) {
                                            //index is present
                                            foundCatIndex = true;

                                            //store the found index in a variable
                                            var itemIndex =
                                                subjectsMarksList.indexOf(item);
                                            // logger.i(
                                            //     "index of the subject is ==> ,$itemIndex");

                                            Map<String, dynamic> editMarksNew =
                                                {};
                                            editMarksNew["0"] =
                                                subjectsMarksList[itemIndex]
                                                    [subjectsList[index]];
                                            // logger.i(
                                            //     "This is the subject and marks\n"
                                            //     "$editMarksNew");

                                            final List<dynamic> indexMarks = [];
                                            indexMarks.add(
                                                subjectsMarksList[itemIndex]
                                                    [subjectsList[index]]);

                                            setState(() {
                                              _userSubject =
                                                  subjectsList[index];
                                              logger.i(_userSubject);
                                            });

                                            // logger.i(
                                            //     "Index of Marks stored ==> $indexMarks");
                                            ////get this subjectsList[index]
                                            // and check for docs containing a
                                            // field subjectsList[index]

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LearnerViewMarks(
                                                  indexMarks: indexMarks,
                                                  subjectName:
                                                      _userSubject.toString(),
                                                ),
                                              ),
                                            );
                                            break;
                                          }
                                        }
                                        //if the teacherSubject is not found

                                        if (!foundCatIndex) {
                                          // handle case where 'CAT' index does not exist
                                          // logger.i(
                                          //     'No ${subjectsList[index]} index found');
                                          snack(
                                              "No ${subjectsList[index]} marks found",
                                              context);
                                        }
                                        //check if the stored data is a Map
                                      } else if (subjectsMarksList is Map) {
                                        //store the teacherSubject here
                                        var teacherSubject = subjectsMarksList[
                                            subjectsList[index]];
                                        // logger.i(
                                        //     'Found $teacherSubject index found');
                                      } else {
                                        // handle case where teacherSubject index does not exist
                                        // logger.i(
                                        //     'No ${subjectsList[index]} index found');
                                        snack("No ${subjectsList[index]}",
                                            context);
                                      }
                                    } else {
                                      // handle case where document does not exist
                                      // logger.i('Document does not exist');
                                      snack(
                                          "No document containing the subject",
                                          context);
                                    }

                                    setState(() {
                                      loading = false;
                                    });
                                  } catch (e) {
                                    snack(e.toString(), context);
                                  }
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    //screen background color
                                    gradient: LinearGradient(
                                        colors: [
                                          Color(0x00cccccc),
                                          Color(0xE7791971)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight),
                                  ),
                                  //color: Theme.of(context).primaryColor,
                                  child: ListTile(
                                    title: loading
                                        ? SpinKitChasingDots(
                                            color:
                                                Theme.of(context).primaryColor,
                                          )
                                        : Text(
                                            subject ?? "",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w900,
                                                color: Theme.of(context)
                                                    .primaryColorLight),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LearnerEditSubjects(),
                        ),
                      );
                    },
                    child: Text(
                      "Edit Subjects",
                      style: textStyleText(context),
                    ),
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
                    user!.email.toString()[0].toUpperCase() ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                Text(
                  user!.email.toString().toUpperCase().substring(0, 5),
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColorLight),
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
                fontWeight: FontWeight.w900,
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
