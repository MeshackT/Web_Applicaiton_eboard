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
import 'package:logger/logger.dart';
import 'package:yueway/AllNew/screens/Notifications/local_notifications.dart';
import 'package:yueway/AllNew/screens/gradeList/NavigationDrawerMobile.dart';
import 'package:yueway/AllNew/screens/home/DesktopHomeLayouts/DesktopHome.dart';

import '../../../testing_messaging/messaging.dart';
import '../../shared/constants.dart';
import '../Authentication/Authenticate.dart';
import '../Authentication/TeacherProfile.dart';
import '../gradeList/grade10.dart';
import '../gradeList/grade11.dart';
import '../gradeList/grade12.dart';
import '../gradeList/grade8.dart';
import '../gradeList/grade9.dart';
import '../more/more.dart';

//get current logged in user
User? user = FirebaseAuth.instance.currentUser;
Logger logger = Logger(printer: PrettyPrinter(colors: true));
//for drawer
String teachersName = "";
String teachersSecondName = "";
String teachersEmail = "";
String teachersGrade = "";
// String teachersSubject1 = "";
// String teachersSubject2 = "";

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
  LocalNotificationService localNotificationService =
      LocalNotificationService();
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
  int selectedItemIndex = -1;
  bool isAlertSet = false;

  //connectivity
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  var isDeviceConnectedOnChange = false;

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
  String teachersSubject2 = "";
  String uidOfTeacher = '';

  @override
  void initState() {
    getConnectivity();
    super.initState();
    localNotificationService.getPermission();
    _getUserField();
    _getCurrentUserFields(
        teachersName, teachersSecondName, teachersEmail, teachersGrade);
  }

  // function to request notifications permissions
  getConnectivity() {
    try {
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
        }
      });
    } on Exception catch (e) {
      // TODO
      Fluttertoast.showToast(msg: e.toString());
    }
    setState(() {
      isAlertSet = false;
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
              //final navigatorPop = Navigator.of(context);
              isDeviceConnected =
                  await InternetConnectionChecker().hasConnection;
              isDeviceConnectedOnChange =
                  InternetConnectionChecker().isActivelyChecking;
              if (!isDeviceConnected && isDeviceConnectedOnChange) {
                logger.i(isDeviceConnectedOnChange);
                logger.i(isDeviceConnected);
                showDialogBox();
              } else {
                Navigator.pop(context, 'Cancel');
              }
              setState(() {
                isAlertSet = false;
              });
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
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < Utils.mobileWidth) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "All learner's list",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            elevation: 0.0,
            centerTitle: true,
            backgroundColor: const Color(0xE7791971),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            actions: [
              loading
                  ? SpinKitChasingDots(
                      color: Theme.of(context).primaryColorLight,
                      size: 15,
                    )
                  : const SizedBox(
                      child: Text(""),
                    ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const Messaging()));
                },
                icon: Icon(
                  Icons.dynamic_feed,
                  color: Theme.of(context).primaryColorLight,
                ),
              )
            ],
          ),
          drawer: const NavigationDrawerForALlMobile(),
          drawerScrimColor: Colors.transparent,
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
              decoration: const BoxDecoration(
                //screen background color
                gradient: LinearGradient(
                    colors: [Color(0x0fffffff), Color(0xE7791971)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: SizedBox(
                      // color:
                      //     Theme.of(context).primaryColorLight.withOpacity(.8),
                      child: TextField(
                        controller: _searchController,
                        cursorColor: Theme.of(context).primaryColorDark,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColorDark,
                                width: 1.0),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColorDark,
                                width: 1.0),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColorDark,
                                width: 1.0),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red, width: 1.0),
                            borderRadius: BorderRadius.circular(30),
                          ),
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
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchText = value;
                          });
                        },
                      ),
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
                                  showDialogBox(),
                                ],
                              ));
                            } else if (streamSnapshot.hasError) {
                              return Text("Error: ${streamSnapshot.error}");
                            } else if (!streamSnapshot.hasData ||
                                streamSnapshot.data == null ||
                                streamSnapshot.data!.size <= 0) {
                              return Center(
                                child: Text(
                                  "No list of learners yet.",
                                  style: textStyleText(context).copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              );
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
                                    String secondNameOfLearner =
                                        documents[index].get("secondName");
                                    String gradeOfLeaner =
                                        documents[index].get("grade");
                                    String emailOfLearner =
                                        documents[index].get("email");
                                    List<String> subjectsOfLeaner = [];

                                    var data =
                                        documents[index].get(("subjects"));

                                    if (data is List) {
                                      for (var item in data) {
                                        subjectsOfLeaner.add(item);
                                      }
                                    }
                                    subjectsOfLeaner.sort();

                                    //TODO SHOW Sheet
                                    showSheetToEdit(
                                        context,
                                        nameOfLearner,
                                        secondNameOfLearner,
                                        gradeOfLeaner,
                                        emailOfLearner,
                                        subjectsOfLeaner);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3.0),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      child: Container(
                                        color: Theme.of(context)
                                            .primaryColorLight
                                            .withOpacity(.3),
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 0.0),
                                          leading: CircleAvatar(
                                            backgroundColor: Theme.of(context)
                                                .primaryColorDark,
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
                                          subtitle: Row(
                                            children: [
                                              Text(
                                                "Grade  ${documents[index]['grade']}",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColorDark
                                                        .withOpacity(.7),
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              Utils.toolTipMessage(
                                                  "Press and hold to view details",
                                                  context),
                                            ],
                                          ),
                                          trailing: SizedBox(
                                            width: 110,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    showThis(
                                                        documents[index].id,
                                                        _userSubject);
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    size: 20,
                                                    color: Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(.6),
                                                  ),
                                                ),
                                                // const SizedBox(
                                                //   width: 10,
                                                // ),
                                                IconButton(
                                                    color: Colors.blue,
                                                    onPressed: () async {
                                                      _getUserField();
                                                      setState(() {
                                                        _userSubject;
                                                        nameOfTeacher;
                                                        selectedItemIndex =
                                                            index;
                                                        loading = true;
                                                      });
                                                      logger.i(
                                                          'User subject: $_userSubject User Name: $nameOfTeacher');

                                                      try {
                                                        //get the documents data from firestore
                                                        DocumentSnapshot
                                                            snapshot =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'learnersData')
                                                                .doc(documents[
                                                                        index]
                                                                    .id)
                                                                .get();
                                                        DocumentSnapshot
                                                            snapshotTeacher =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'userData')
                                                                .doc(
                                                                    uidOfTeacher)
                                                                .get();

                                                        if (snapshot.exists) {
                                                          // go to the field in the document
                                                          var data = snapshot.get(
                                                              ("allSubjects"));
                                                          var dataSub1 =
                                                              snapshotTeacher.get(
                                                                  'subjects')[0];
                                                          var dataSub2 =
                                                              snapshotTeacher.get(
                                                                  'subjects')[1];

                                                          DocumentReference
                                                              docRef =
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'learnersData')
                                                                  .doc(documents[
                                                                          index]
                                                                      .id);

                                                          // check if the data is a Map
                                                          if (data is Map) {
                                                            logger.e(data);
                                                            // check if the user subject exists in the Map
                                                            if (data.containsKey(
                                                                _userSubject)) {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          "Already registered $_userSubject");
                                                              setState(() {
                                                                isRegistered =
                                                                    true;
                                                                loading = false;
                                                              });
                                                              return;
                                                            } else if (data
                                                                .containsKey(
                                                                    teachersSubject2)) {
                                                              // user subject2 is already registered
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          "Already registered $teachersSubject2");
                                                              setState(() {
                                                                isRegistered =
                                                                    true;
                                                                loading = false;
                                                              });
                                                              return;

                                                              //if the array map doesnt have either then do this
                                                            } else {
                                                              // get these values from the database
                                                              name = documents[
                                                                          index]
                                                                      [
                                                                      'name'] ??
                                                                  "";
                                                              grade = documents[
                                                                          index]
                                                                      [
                                                                      'grade'] ??
                                                                  "";
                                                              List<dynamic>
                                                                  subjectsIndex =
                                                                  documents[index]
                                                                          [
                                                                          'subjects'] ??
                                                                      "";

                                                              // add marks to a Map
                                                              Map<String,
                                                                      dynamic>
                                                                  testsMarks = {
                                                                'test1mark': "",
                                                                'test2mark': "",
                                                                'test3mark': "",
                                                                'test4mark': ""
                                                              };
                                                              Map<String,
                                                                      dynamic>
                                                                  assignmentsMarks =
                                                                  {
                                                                'assignment1mark':
                                                                    "",
                                                                'assignment2mark':
                                                                    "",
                                                                'assignment3mark':
                                                                    "",
                                                                'assignment4mark':
                                                                    ""
                                                              };
                                                              Map<String,
                                                                      dynamic>
                                                                  examMarks = {
                                                                'exam1mark': "",
                                                                'exam2mark': ""
                                                              };
                                                              Map<String,
                                                                      dynamic>
                                                                  addAllMark = {
                                                                "tests":
                                                                    testsMarks,
                                                                "assignments":
                                                                    assignmentsMarks,
                                                                "exams":
                                                                    examMarks
                                                              };

                                                              //add according to subject present
                                                              Map<String,
                                                                      dynamic>
                                                                  finalMarks = {
                                                                _userSubject:
                                                                    List.generate(
                                                                        4,
                                                                        (_) =>
                                                                            addAllMark)
                                                              };
                                                              Map<String,
                                                                      dynamic>
                                                                  finalMarks2 =
                                                                  {
                                                                teachersSubject2:
                                                                    List.generate(
                                                                        4,
                                                                        (_) =>
                                                                            addAllMark)
                                                              };

                                                              // update the document with the new subject data
                                                              DocumentReference
                                                                  docRef =
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'learnersData')
                                                                      .doc(documents[
                                                                              index]
                                                                          .id);

                                                              bool docExists = await docRef
                                                                  .get()
                                                                  .then((docSnapshot) =>
                                                                      docSnapshot
                                                                          .exists);

                                                              if (snapshot.data() !=
                                                                      null &&
                                                                  docExists) {
                                                                if ((docRef
                                                                        .collection(
                                                                            'learnersData')
                                                                        .where(
                                                                            'teachersID',
                                                                            arrayContains:
                                                                                user!.uid) !=
                                                                    null)) {
                                                                  int index1 =
                                                                      subjectsIndex
                                                                          .indexOf(
                                                                              dataSub1);
                                                                  int index2 =
                                                                      subjectsIndex
                                                                          .indexOf(
                                                                              dataSub2);
                                                                  if (index1 !=
                                                                      -1) {
                                                                    await docRef.update({
                                                                      'allSubjects':
                                                                          {
                                                                        ...data,
                                                                        ...finalMarks
                                                                      }
                                                                    }).catchError((error) =>
                                                                        Fluttertoast.showToast(
                                                                            msg:
                                                                                'Error updating Map field: $error'));
                                                                    Fluttertoast.showToast(
                                                                        backgroundColor:
                                                                            Theme.of(context)
                                                                                .primaryColor,
                                                                        msg:
                                                                            "Registering $_userSubject");

                                                                    logger.i(
                                                                        "The index of '$dataSub1' in 'subjectsIndex' is $index.");
                                                                  } else if (index2 !=
                                                                      -1) {
                                                                    await docRef.update({
                                                                      'allSubjects':
                                                                          {
                                                                        ...data,
                                                                        ...finalMarks2
                                                                      }
                                                                    }).catchError((error) =>
                                                                        Fluttertoast.showToast(
                                                                            msg:
                                                                                'Error updating Map field: $error'));
                                                                    Fluttertoast.showToast(
                                                                        backgroundColor:
                                                                            Theme.of(context)
                                                                                .primaryColor,
                                                                        msg:
                                                                            "Registering $dataSub1");
                                                                    logger.i(
                                                                        "The index of '$dataSub2' in 'subjectsIndex' is $index.");
                                                                  } else {
                                                                    logger.i(
                                                                        "'$dataSub1' was not found in 'subjectsIndex'.");
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "Cannot register either of these subjects: "
                                                                                "$teachersSubject2 & $_userSubject");
                                                                  }
                                                                } else {
                                                                  Fluttertoast.showToast(
                                                                      backgroundColor:
                                                                          Theme.of(context)
                                                                              .primaryColor,
                                                                      msg:
                                                                          "You are not their teacher.");
                                                                  logger.e(
                                                                      "You are not registered as their teacher");
                                                                }
                                                              } else {
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Learner registered already.");
                                                                logger.i(
                                                                    "Document already exists, leaner registered");
                                                              }
                                                            }
                                                          } else {
                                                            logger.i(
                                                                "field is Not a map");
                                                          }
                                                        } else {
                                                          // handle case where document does not exist
                                                          logger.i(
                                                              'Document does not exist');
                                                        }
                                                      } catch (e) {
                                                        logger.i(e);
                                                        ScaffoldMessenger.of(
                                                                context)
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
                                                        logger.i(
                                                            documents[index]
                                                                [user!.uid]);
                                                      }
                                                      setState(() {
                                                        loading = false;
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.add,
                                                      size: 20,
                                                      key: ValueKey(
                                                          documents[index]),
                                                      color:
                                                          IconTheme.of(context)
                                                              .color!
                                                              .withOpacity(.7),
                                                    )),
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
        );
      } else {
        return const DesktopHomeLayout();
      }
    });
  }

  //TODO Show bottom Sheet To add Subject to the learner
  showSheetToEdit(BuildContext context, String nOfLearner, String sNOfLearner,
      String gOfLearner, String eOfLearner, List<String> sOfLearner) {
    showModalBottomSheet(
      barrierColor: Theme.of(context).primaryColor.withOpacity(.1),
      isScrollControlled: true,
      enableDrag: true,
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      backgroundColor: Theme.of(context).primaryColorLight,
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Name",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(.70)),
                        ),
                        Text(
                          nOfLearner,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Second Name",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(.70)),
                        ),
                        Text(
                          sNOfLearner,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Grade",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(.70)),
                        ),
                        Text(
                          gOfLearner,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Email",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(.70)),
                        ),
                        Text(
                          eOfLearner,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(.70)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.0),
                      child: Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 19),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Subjects",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .primaryColorDark
                                            .withOpacity(.70)),
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: buttonRound,
                                  child: Text(
                                    "Close",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                                //reverse: true,
                                itemCount: sOfLearner.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return SizedBox(
                                    height: 40,
                                    child: ListTile(
                                      title: Wrap(
                                        alignment: WrapAlignment.end,
                                        children: [
                                          Text(
                                            sOfLearner[index],
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
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
            ),
          ],
        );
      },
    );
  }

  ///TODO Make this also delete the account of the learner
  ///TODO Make this also delete the account of the learner
  ///TODO Make this also delete the account of the learner
  Future showThis(String indexId, String userSubject) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            textAlign: TextAlign.center,
            'Permanently Delete the learner',
            style: TextStyle(
                color: Colors.red, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          content: Text(
            'This action will '
            'permanently '
            'delete the learners and will require re-registering'
            ' $userSubject for this learner, '
            'are you sure you '
            'want to delete the learner?',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).primaryColorDark.withOpacity(.70)),
          ),
          actions: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Discard',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: TextButton(
                      onPressed: () async {
                        //Delete the record
                        try {
                          //TODO deletes the document of the learner
                          await FirebaseFirestore.instance
                              .collection("learnersData")
                              .doc(indexId)
                              .delete();
                          Fluttertoast.showToast(
                              msg: "Learner deleted from the database");
                          logger.i("Document index $indexId is deleted");
                          Navigator.of(context).pop();
                        } catch (e) {
                          logger.i(e);
                          snack("Could not delete the learner", context);
                        }
                      },
                      child: Text(
                        'Proceed',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  //Check if learners in the database have a subject based on the current logged in teacher
  Future<void> checkAllSubjects() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('learnersData')
        .where("allSubjects", arrayContains: _userSubject)
        .get();

    var documents = snapshot.docs;

    if (documents.isNotEmpty) {
      for (var document in documents) {
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

  //For Drawer
  Future<void> _getCurrentUserFields(
    String nameOfTeacherForDrawer,
    String secondNameOfTeacherForDrawer,
    String emailOfTeacherForDrawer,
    String gradeOfTeacherDrawer,
  ) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    var userQuery =
        firestore.collection('userData').where('uid', isEqualTo: user!.uid);
    userQuery.get().then((var querySnapshot) {
      if (querySnapshot.size > 0) {
        var documentSnapshot = querySnapshot.docs.first;
        Map<String, dynamic>? data = documentSnapshot.data();

        //get the learners details
        nameOfTeacherForDrawer = data['name'].toString();
        secondNameOfTeacherForDrawer = data['secondName'].toString();
        emailOfTeacherForDrawer = data['email'].toString();
        gradeOfTeacherDrawer = data['grade'].toString();
        // subject2OfTeacherForDrawer = data['subjects'][1].toString();

        setState(() {
          uidOfTeacher = data['documentID'].toString();
          teachersName = nameOfTeacherForDrawer.toString();
          teachersSecondName = secondNameOfTeacherForDrawer.toString();
          teachersEmail = emailOfTeacherForDrawer.toString();
          teachersGrade = gradeOfTeacherDrawer.toString();
          // teachersSubject1 = subject1OfTeacherForDrawer.toString();
          // teachersGrade = subject2OfTeacherForDrawer.toString();
        });
      } else {
        Fluttertoast.showToast(
            backgroundColor: Theme.of(context).primaryColor,
            msg: "No data found");
        print('No document found');
      }
    }).catchError((error) => print('Failed to get document: $error'));
  }

  //get the field required for the current logged in user (current logged in Subject)
  Future<void> _getUserField() async {
    // Get the current user's ID
    //String? userId = FirebaseAuth.instance.currentUser?.uid;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    var userQuery =
        firestore.collection('userData').where('uid', isEqualTo: user!.uid);
    userQuery.get().then((var querySnapshot) {
      if (querySnapshot.size > 0) {
        var documentSnapshot = querySnapshot.docs.first;
        Map<String, dynamic>? data = documentSnapshot.data();
        // get the subject 1 field or empty string if it doesn't exist
        _userSubject = data['subjects'][0] ?? '';
        // get the subject 2 field or empty string if it doesn't exist
        teachersSubject2 = data['subjects'][1] ?? '';
        // get the name field or empty string if it doesn't exist
        nameOfTeacher = data['name'] ?? '';

        uidOfTeacher = data['documentID'] ?? '';

        logger.e("inside getting fields $_userSubject and $teachersSubject2");
      } else {
        print('No document found');
      }
    }).catchError((error) => print('Failed to get document: $error'));
  }

  Future<void> loopAllSubjects() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('learnersData').get();

    var documents = snapshot.docs;

    for (var document in documents) {
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
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).primaryColorLight,
          width: MediaQuery.of(context).size.width / 1.8,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildHeader(context),
                buildMenueItems(context),
              ],
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
          child: InkWell(
            onTap: () {
              logger.i("ProfileTap $teachersName");
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const TeachersProfile()));
            },
            child: Container(
              color: Theme.of(context).primaryColorDark.withOpacity(.8),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColorLight,
                    child: Wrap(
                      children: [
                        Text(
                          teachersSecondName[0].toString() ?? "",
                          style: textStyleText(context).copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color:
                                Theme.of(context).primaryColor.withOpacity(.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    children: [
                      Text(
                        teachersSecondName.toString() ?? "",
                        style: textStyleText(context).copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 22,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Wrap(
            children: [
              Text(
                teachersEmail.toString(),
                style: textStyleText(context).copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
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
        padding: const EdgeInsets.only(top: 0),
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
                Icons.school,
                color: IconTheme.of(context).color,
              ),
              title: Text(
                "Grade 9",
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w700),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Grade9()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.school,
                color: IconTheme.of(context).color,
              ),
              title: Text(
                "Grade 8",
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w700),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Grade8()));
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
              onTap: () async {
                await sigOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future sigOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut().then((value) => SpinKitChasingDots(
            color: Theme.of(context).primaryColor,
          ));
      await FirebaseAuth.instance.signOut().then((value) => SpinKitChasingDots(
            color: Theme.of(context).primaryColor,
          ));
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Authenticate()));
        } else {
          return;
          // Fluttertoast.showToast(
          //     backgroundColor: Theme.of(context).primaryColor,
          //     msg: 'Could not log out, you are still signed in!');
        }
      });
    } catch (e) {
      Fluttertoast.showToast(
          backgroundColor: Theme.of(context).primaryColor,
          msg: 'Could not log out, you are still signed in!\n${e.toString()}');
    }
  }
}
