import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:levy/AllNew/screens/Authentication/Authenticate.dart';
import 'package:levy/AllNew/screens/gradeList/grade11.dart';
import 'package:levy/AllNew/screens/more/more.dart';

import '../../shared/constants.dart';
import '../gradeList/grade10.dart';
import '../gradeList/grade12.dart';

//get current logged in user
User? user = FirebaseAuth.instance.currentUser;

class Subjects {
  String? indexOfDoc;
  String? subject;

  Subjects(this.subject);

  Future<void> addSubject(
    indexOfDoc,
    subject,
    Map<String, dynamic> finalMarks,
  ) {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('learnersData').doc(indexOfDoc);
    Map<String, Object?> newData = {
      subject: finalMarks,
    };
    // Call the user's CollectionReference to add a new user
    return docRef
        .update(
          {
            'allSubjects': FieldValue.arrayUnion(newData as List),
          },
        )
        .then((value) => print("User Data"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = '';

  //String searchN="";

  CollectionReference allLearnersCollection =
      FirebaseFirestore.instance.collection('learnersData');
  List<DocumentSnapshot> documents = [];

  //////////////////////////////
  List<Map<dynamic, dynamic>> lists = [];
  final databaseReference =
      FirebaseFirestore.instance.collection("learnersData");

  /////////////////////////////
//properties required
  String uid = "";
  String documentID = "";
  String name = "";
  String grade = "";
  String subject1 = "";
  String learnersDocumentID = "";
  String term1Mark1 = "";
  String term1Mark2 = "";
  String term1Mark3 = "";
  String term1Mark4 = "";
  String term1Assignment1 = "";
  String term1Assignment2 = "";
  String term1Assignment3 = "";
  String term1Assignment4 = "";
  String exam1 = "";
  String exam2 = "";

  //var teachersName =
  var subjectMarks1 = {};
  var subjectMarks2 = {};
  var subjectMarks3 = {};
  var subjectMarks4 = {};
  var subjectMarks = [];

  //String documentId = "";
  bool loading = false;
  bool isVisible = false;
  bool isRegistered = false;

  //connectivity
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  var isDeviceConnectedOnChange = false;
  bool isAlertSet = false;

  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    subscription.cancel();
    super.dispose();
  }

  String nameOfTeacher = "";
  String _userSubject = '';

  @override
  void initState() {
    getConnectivity();
    super.initState();
    _getUserField();
  }

  getConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected && isAlertSet == false) {
        logger.i(isDeviceConnected);
        showDialogBox();
        setState(() {
          isAlertSet = true;
        });
      } else {
        logger.i(isDeviceConnected);

        setState(() {
          isAlertSet = false;
        });
      }
    });
  }

  showDialogBox() {
    return showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          "No Connection to the internet",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context, 'Cancel');
              setState(() {
                isAlertSet = false;
              });
              isDeviceConnected =
                  await InternetConnectionChecker().hasConnection;
              isDeviceConnectedOnChange =
                  InternetConnectionChecker().isActivelyChecking;
              if (!isDeviceConnected && isDeviceConnectedOnChange) {
                logger.i(isDeviceConnectedOnChange);
                logger.i(isDeviceConnected);
                showDialogBox();
                setState(() {
                  isAlertSet = true;
                });
              } else {
                setState(() {
                  isAlertSet = true;
                });
              }
            },
            child: const Text('OK'),
          ),
        ],
        content: const Text("Please check your internet connection"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All learners list",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: const Color(0xE7791971),
      ),
      drawer: const NavigationDrawer(),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(1),
          content: Text(
            'Tap back again to leave the application',
            style: TextStyle(color: Theme.of(context).primaryColorLight),
            textAlign: TextAlign.center,
          ),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height,
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
              isVisible
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Container(
                        color:
                            Theme.of(context).primaryColorLight.withOpacity(.8),
                        child: TextField(
                          controller: _searchController,
                          cursorColor: Theme.of(context).primaryColorDark,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorDark,
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.only(
                              left: 15,
                              bottom: 11,
                              top: 11,
                              right: 15,
                            ),
                            hintText: "Enter a name",
                            hintStyle: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1),
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () {
                                setState(() {
                                  _searchController.text = "";
                                });
                              },
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchText = value;
                            });
                          },
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Search for a learner",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Theme.of(context).primaryColorDark),
                      ),
                    ),
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: StreamBuilder(
                      stream: allLearnersCollection
                          .where('teachersID', arrayContains: user!.uid)
                          .snapshots(),
                      builder: (ctx, streamSnapshot) {
                        if (streamSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: Column(
                            children: [
                              Text(
                                'Waiting for Internet Connection',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                              SpinKitChasingDots(
                                color: Theme.of(context).primaryColorDark,
                                size: 15,
                              ),
                            ],
                          ));
                        } else if (streamSnapshot.connectionState ==
                            ConnectionState.none) {
                          return Center(
                              child: Column(
                            children: [
                              Text(
                                'No for Internet Connection',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                              SpinKitChasingDots(
                                color: Theme.of(context).primaryColorDark,
                                size: 15,
                              ),
                            ],
                          ));
                        }
                        documents = streamSnapshot.data!.docs;
                        //todo Documents list added to filterTitle
                        if (searchText.isNotEmpty) {
                          documents = documents.where((element) {
                            return element
                                .get('name')
                                .toString()
                                .toLowerCase()
                                .contains(searchText.toLowerCase());
                          }).toList();
                        }

                        return ListView.builder(
                          //reverse: true,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onLongPress: () async {
                                String nameOfLearner =
                                    documents[index].get("name");
                                String gradeOfLeaner =
                                    documents[index].get("grade");
                                String emailOfLearner =
                                    documents[index].get("email");
                                List<String> subjectsOfLeaner = [];

                                var data = documents[index].get(("subjects"));

                                if (data is List) {
                                  for (var item in data) {
                                    subjectsOfLeaner.add(item);
                                  }
                                }
                                subjectsOfLeaner.sort();

                                //show the dialog when you press delete
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        textAlign: TextAlign.center,
                                        'Learners Details',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      content: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.height /
                                                1.5,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                1.4,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Name",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .primaryColorDark
                                                          .withOpacity(.70)),
                                                ),
                                                Text(
                                                  nameOfLearner,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .primaryColorDark
                                                          .withOpacity(.70)),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Grade",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .primaryColorDark
                                                          .withOpacity(.70)),
                                                ),
                                                Text(
                                                  gradeOfLeaner,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .primaryColorDark
                                                          .withOpacity(.70)),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Email",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .primaryColorDark
                                                          .withOpacity(.70)),
                                                ),
                                                Text(
                                                  emailOfLearner,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .primaryColorDark
                                                          .withOpacity(.70)),
                                                ),
                                              ],
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.0),
                                              child: Divider(
                                                height: 1,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  1.8,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 19),
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            "Subjects",
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColorDark
                                                                    .withOpacity(
                                                                        .70)),
                                                          ),
                                                        ),
                                                        OutlinedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          style: buttonRound,
                                                          child: Text(
                                                            "Done",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColorDark,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: ListView.builder(
                                                        //reverse: true,
                                                        itemCount:
                                                            subjectsOfLeaner
                                                                .length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return SizedBox(
                                                            height: 40,
                                                            child: ListTile(
                                                              title: Wrap(
                                                                alignment:
                                                                    WrapAlignment
                                                                        .end,
                                                                children: [
                                                                  Text(
                                                                    subjectsOfLeaner[
                                                                        index],
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Theme.of(context)
                                                                            .primaryColorDark
                                                                            .withOpacity(.70)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3.0),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                  child: Container(
                                    color: Theme.of(context)
                                        .primaryColorLight
                                        .withOpacity(.8),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 0.0),
                                      leading: CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).primaryColorDark,
                                        child: Text(
                                          documents[index]['name'][0],
                                        ),
                                      ),
                                      title: Text(
                                        documents[index]['name'],
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Grade  ${documents[index]['grade']}",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorDark
                                                .withOpacity(.7),
                                            fontWeight: FontWeight.w700),
                                      ),
                                      trailing: SizedBox(
                                        width: 50,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              color: Colors.blue,
                                              onPressed: () async {
                                                _getUserField();
                                                setState(() {
                                                  _userSubject;
                                                  nameOfTeacher;
                                                });
                                                logger.i(
                                                    'User subject: $_userSubject User Name: $nameOfTeacher');

                                                try {
                                                  final DocumentReference
                                                      documentRef =
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'learnersData')
                                                          .doc(documents[index]
                                                              .id);

                                                  // Get the document snapshot
                                                  final DocumentSnapshot
                                                      documentSnapshot =
                                                      await documentRef.get();
                                                  //get the documents data from firestore
                                                  DocumentSnapshot snapshot =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'learnersData')
                                                          .doc(documents[index]
                                                              .id) // replace 'documentID' with the actual ID of the document
                                                          .get();

                                                  //check if the document exits
                                                  if (snapshot.exists) {
                                                    //go to the field in the document
                                                    var data = snapshot
                                                        .get(("allSubjects"));
                                                    //check if the data is a List
                                                    if (data is List) {
                                                      bool foundCatIndex =
                                                          false;
                                                      //for every item in the list
                                                      for (var item in data) {
                                                        //if the item is==$userSubject
                                                        if (item.containsKey(
                                                            _userSubject)) {
                                                          //index is present
                                                          foundCatIndex = true;
                                                          //get the teacher subject from the list
                                                          //logger.i("Found found found");
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Already registered");
                                                          // do something with the 'CAT' data, such as print it
                                                          break;
                                                        }
                                                      }

                                                      //if the teacherSubject is not found

                                                      if (!foundCatIndex) {
                                                        Fluttertoast.showToast(
                                                            msg: "registering");

                                                        // handle case where 'CAT' index does not exist
                                                        ///TODO add subject
                                                        //get these values from the database
                                                        name = documents[index]
                                                                ['name'] ??
                                                            "";
                                                        grade = documents[index]
                                                                ['grade'] ??
                                                            "";

                                                        ////////////adds marks to an array///////////////
                                                        //////////////////////////////////////////////////
                                                        //add test mark in a dict list
                                                        subjectMarks1[
                                                                'test1mark'] =
                                                            term1Mark1;
                                                        subjectMarks1[
                                                                'test2mark'] =
                                                            term1Mark2;
                                                        subjectMarks1[
                                                                'test3mark'] =
                                                            term1Mark3;
                                                        subjectMarks1[
                                                                'test4mark'] =
                                                            term1Mark4;

                                                        //add assignment marks in a dict list
                                                        subjectMarks1[
                                                                'assignment1mark'] =
                                                            term1Assignment1;
                                                        subjectMarks1[
                                                                'assignment2mark'] =
                                                            term1Assignment2;
                                                        subjectMarks1[
                                                                'assignment3mark'] =
                                                            term1Assignment3;
                                                        subjectMarks1[
                                                                'assignment4mark'] =
                                                            term1Assignment4;

                                                        //add exam in a dict list
                                                        subjectMarks1[
                                                                'exam1mark'] =
                                                            exam1;
                                                        subjectMarks1[
                                                                'exam2mark'] =
                                                            exam2;
                                                        // subjectMarks1['currentMarkTeacher'] = user!.uid;

                                                        //************************************//
                                                        ///////start adding marks//////////
                                                        Map<String, dynamic>
                                                            testsMarks = {};
                                                        Map<String, dynamic>
                                                            assignmentsMarks =
                                                            {};
                                                        Map<String, dynamic>
                                                            examMarks = {};
                                                        Map<String, dynamic>
                                                            addAllMark = {};
                                                        Map<String, dynamic>
                                                            finalMarks = {};
                                                        Map<String, dynamic>
                                                            indexNumbers = {};
                                                        int count = 0;

                                                        testsMarks[
                                                            'test1mark'] = "";
                                                        testsMarks[
                                                            'test2mark'] = "";
                                                        testsMarks[
                                                            'test3mark'] = "";
                                                        testsMarks[
                                                            'test4mark'] = "";

                                                        //add assignment marks in a dict list
                                                        assignmentsMarks[
                                                            'assignment1mark'] = "";
                                                        assignmentsMarks[
                                                            'assignment2mark'] = "";
                                                        assignmentsMarks[
                                                            'assignment3mark'] = "";
                                                        assignmentsMarks[
                                                            'assignment4mark'] = "";

                                                        //add exam in a dict list
                                                        examMarks['exam1mark'] =
                                                            "";
                                                        examMarks['exam2mark'] =
                                                            "";

                                                        addAllMark["tests"] =
                                                            testsMarks;
                                                        addAllMark[
                                                                "assignments"] =
                                                            assignmentsMarks;
                                                        addAllMark["exams"] =
                                                            examMarks;

                                                        //add marks holder 4 terms in an array list
                                                        for (int i = 0;
                                                            i < 4;
                                                            i++) {
                                                          //subjectMarks.add(subjectMarks1);
                                                          indexNumbers[(count++)
                                                                  .toString()] =
                                                              addAllMark;
                                                        }
                                                        finalMarks[
                                                                _userSubject] =
                                                            indexNumbers;
                                                        logger.i(documents[
                                                                index]
                                                            ["allSubjects"]);

                                                        ////////////////End of adding marks///////////////
                                                        //Assuming you have a reference to your document
                                                        DocumentReference docRef =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'learnersData')
                                                                .doc(documents[
                                                                        index]
                                                                    .id);
                                                        // Get the document snapshot
                                                        DocumentSnapshot
                                                            docSnapshot =
                                                            await docRef.get();

                                                        bool docExists =
                                                            await docRef.get().then(
                                                                (docSnapshot) =>
                                                                    docSnapshot
                                                                        .exists);

                                                        // Check if the 'uid' field exists in the document data
                                                        if (docSnapshot
                                                                    .data() !=
                                                                null &&
                                                            docExists) {
                                                          if ((docRef
                                                                  .collection(
                                                                      'learnersData')
                                                                  .where(
                                                                      'teachersID',
                                                                      arrayContains:
                                                                          user!
                                                                              .uid) !=
                                                              null)) {
                                                            setState(() {
                                                              loading = true;
                                                            });

                                                            await docRef
                                                                .update({
                                                                  'allSubjects':
                                                                      FieldValue
                                                                          .arrayUnion([
                                                                    finalMarks
                                                                  ])
                                                                })
                                                                .then((value) =>
                                                                    setState(
                                                                        () {
                                                                      loading =
                                                                          false;
                                                                    }))
                                                                .catchError(
                                                                    (error) =>
                                                                        print(
                                                                            'Error updating map field: $error'));
                                                          } else {
                                                            print(
                                                                'Learner is not doing the subject');
                                                          }
                                                        } else {
                                                          print(
                                                              "Document already exists");
                                                        }

                                                        ////TODO ENds
                                                      }
                                                    }
                                                  } else {
                                                    // handle case where document does not exist
                                                    logger.i(
                                                        'Document does not exist');
                                                  }
                                                } catch (e) {
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                  logger.i(e);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Failed to Register a learner $e',
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      backgroundColor:
                                                          Colors.purple,
                                                    ),
                                                  );
                                                  print(documents[index]
                                                      [user!.uid]);
                                                }
                                              },
                                              icon: loading
                                                  ? const SpinKitChasingDots(
                                                      color: Colors.purple,
                                                      size: 15,
                                                    )
                                                  : Icon(
                                                      Icons.add,
                                                      size: 30,
                                                      color:
                                                          IconTheme.of(context)
                                                              .color!
                                                              .withOpacity(.7),
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
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 80,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: IconTheme.of(context).color,
        onPressed: toggleVisibility,
        child: Icon(
          Icons.search,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
    );
  }

  //Check if learners in the database have a subject based on the current logged in teacher
  Future<void> checkAllSubjects() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('learnersData')
        .where("allSubjects", arrayContains: _userSubject)
        .get();

    final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
        snapshot.docs;

    if (documents.isNotEmpty) {
      for (final QueryDocumentSnapshot<Map<String, dynamic>> document
          in documents) {
        final String documentId = document.id;
        // Do something with the document that contains Mathematics in allSubjects
        logger
            .i('$_userSubject is present in allSubjects field of $documentId');
      }
    } else {
      logger.i(
          'No documents in the collection contain $_userSubject in a field called allSubjects.');
    }
  }

  //get the field required for the current logged in user (current logged in Subject)
  Future<void> _getUserField() async {
    // Get the current user's ID
    //String? userId = FirebaseAuth.instance.currentUser?.uid;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    Query<Map<String, dynamic>> userQuery =
        firestore.collection('userData').where('uid', isEqualTo: user!.uid);
    userQuery.get().then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      if (querySnapshot.size > 0) {
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            querySnapshot.docs.first;
        Map<String, dynamic>? data = documentSnapshot.data();
        _userSubject = data?['subjects'][0] ??
            ''; // get the name field or empty string if it doesn't exist
        nameOfTeacher = data?['name'] ??
            ''; // get the name field or empty string if it doesn't exist
        print('User subject: $_userSubject User Name: $nameOfTeacher');
      } else {
        print('No document found');
      }
    }).catchError((error) => print('Failed to get document: $error'));
  }

  Future<void> loopAllSubjects() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('learnersData').get();

    final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
        snapshot.docs;

    for (final QueryDocumentSnapshot<Map<String, dynamic>> document
        in documents) {
      final List<dynamic> allSubjects = document.data()['allSubjects'];
      // Do something with the allSubjects array
      final Map<String, dynamic> newList = {};
      for (final dynamic subject in allSubjects) {
        newList[document.id] = subject.toString();

        if (newList.containsKey(_userSubject)) {
          logger.i("${document.id} has $_userSubject");
        } else {
          logger.i("${document.id} doesn't have $_userSubject");
        }
      }
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snack(
      String message) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message.toString()),
      duration: const Duration(seconds: 4),
    ));
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width / 1.8,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [buildHeader(context), buildMenueItems(context)],
            ),
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
            color: Theme.of(context).primaryColorDark.withOpacity(.40),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  child: Text(user!.photoURL ??
                      user!.email.toString()[0].toUpperCase()),
                ),
                const SizedBox(
                  height: 22,
                ),
                Text(
                  user!.email.toString().substring(0, 5).toUpperCase(),
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
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
            user!.email.toString().toUpperCase() ?? "",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColorDark),
          ),
        ),
        const SizedBox(
          height: 22,
        ),
      ],
    );
  }

  Widget buildMenueItems(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.home,
                color: IconTheme.of(context).color,
              ),
              title: Text(
                "Home",
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w700),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Home()));
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Divider(
                height: 1,
                color: Theme.of(context).primaryColorDark.withOpacity(.7),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.school,
                color: IconTheme.of(context).color,
              ),
              title: Text(
                "Grade 12",
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w700),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Grade12()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.school,
                color: IconTheme.of(context).color,
              ),
              title: Text(
                "Grade 11",
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w700),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Grade11()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.school,
                color: IconTheme.of(context).color,
              ),
              title: Text(
                "Grade 10",
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w700),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Grade10()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.more,
                color: IconTheme.of(context).color,
              ),
              title: Text(
                "More",
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w700),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const More()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: IconTheme.of(context).color,
              ),
              title: Text(
                "Sign Out",
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w700),
              ),
              onTap: () {
                sigOut(context);
              },
            ),
          ],
        ),
      ),
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
      //ChangeNotifier();
    } catch (e) {
      logger.i(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to Sign Out: $e',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    }
  }
}
