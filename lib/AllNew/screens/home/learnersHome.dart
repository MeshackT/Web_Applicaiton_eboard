import 'package:Eboard/AllNew/screens/Notifications/local_notifications.dart';
import 'package:Eboard/AllNew/screens/more/LearnerMore.dart';
import 'package:Eboard/testing_messaging/LearnerViewDocument.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

import '../../../testing_messaging/LearnerViewAllMessages.dart';
import '../../../testing_messaging/LearnerViewAllTexts.dart';
import '../../model/ConnectionChecker.dart';
import '../../shared/constants.dart';
import '../Authentication/Authenticate.dart';
import '../Authentication/LearnerAuthentication/EditSubjects.dart';
import '../Authentication/LearnerAuthentication/LearnersProfile.dart';
import 'learnerViewMarks.dart';

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
  String _userSubject = '';
  String learnersName = "";
  String learnersSecondName = "";
  String learnersEmail = "";
  LocalNotificationService localNotificationService =
      LocalNotificationService();

  @override
  void initState() {
    super.initState();
    ConnectionChecker.checkTimer();
    _getCurrentUserFields(learnersName, learnersSecondName, learnersEmail);
    //notification
    // LocalNotificationService.initialize();
    // localNotificationService.getPermission();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
          //body: extendBodyBehindAppBar: false,
          drawerScrimColor: Colors.transparent,
          endDrawerEnableOpenDragGesture: true,
          extendBody: true,
          drawer: SafeArea(
            child: Container(
              color: Theme.of(context).primaryColorLight,
              width: MediaQuery.of(context).size.width / 1.4,
              height: MediaQuery.of(context).size.height,
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

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Column(
                              children: [
                                const Text(
                                    "Waiting for the internet connection"),
                                SpinKitChasingDots(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data == null ||
                            snapshot.data!.size <= 0) {
                          return Center(
                            child: Column(
                              children: [
                                Text(
                                  "No Subject yet and still loading...",
                                  style: textStyleText(context).copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context).primaryColor),
                                ),
                                CircularProgressIndicator(
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
                        final Map<String, dynamic> subjectsMarksList =
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: InkWell(
                                  onTap: () async {
                                    setState(() {
                                      loading = true;
                                    });
                                    //check if the document is not empty and get the data
                                    if (subjectsMarksList != null) {
                                      //check if the data is a List
                                      if (subjectsMarksList is Map) {
                                        //initially the subject is no found
                                        bool foundCatIndex = false;
                                        subjectsMarksList.forEach((key, value) {
                                          if (key == subjectsList[index]) {
                                            //if the subject is found
                                            foundCatIndex = true;
                                            //add the marks to this new local Map
                                            Map<String, dynamic> indexMarks =
                                                {};
                                            _userSubject = subjectsList[index];
                                            indexMarks[_userSubject] = value;
                                            // logger.i("$_userSubject\n${ indexMarks[_userSubject] = value}");

                                            Navigator.pushReplacement(
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
                                          }
                                        });
                                        if (!foundCatIndex) {
                                          //this shows when the index has no marks
                                          logger.e("List is Empty");
                                          snack(
                                              "No ${subjectsList[index]} marks found",
                                              context);
                                        }
                                      } else {
                                        snack(
                                            "No ${subjectsList[index]} marks found. No data inserted yet",
                                            context);
                                      }
                                    } else {
                                      logger.e(
                                          "Map is Empty, no subjects instead");
                                      snack("There are no Subjects currently",
                                          context);
                                    }

                                    setState(() {
                                      loading = false;
                                    });
                                  },
                                  child: Container(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(.80),
                                    child: ListTile(
                                      title: loading
                                          ? SpinKitChasingDots(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            )
                                          : Text(
                                              subject.capitalize(),
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
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).primaryColor.withOpacity(.2),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LearnerEditSubjects(),
                            ),
                          );
                        },
                        child: Text(
                          "Edit Subjects",
                          style: textStyleText(context).copyWith(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                floating: true,
                snap: true,
                title: const Text("What's new?"),
                titleSpacing: 2,
                centerTitle: false,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                actions: [
                  // Download
                  loading
                      ? SpinKitChasingDots(
                          size: 13,
                          color: Theme.of(context).primaryColorLight,
                        )
                      : const SizedBox(
                          child: Text(""),
                        ),
                  PopupMenuButton(
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LearnersProfile(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor,
                                size: 12,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "My Profile",
                                style: textStyleText(context).copyWith(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LearnerEditSubjects()));
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.subject,
                                color: Theme.of(context).primaryColor,
                                size: 12,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Edit Subjects",
                                style: textStyleText(context).copyWith(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const LearnerMore()));
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.more_horiz_rounded,
                                color: Theme.of(context).primaryColor,
                                size: 12,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "More",
                                style: textStyleText(context).copyWith(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        child: TextButton(
                          onPressed: () async {
                            try {
                              setState(() {
                                loading == true;
                              });
                              sigOut(context);
                              sigOut(context);
                            } on Exception catch (e) {
                              setState(() {
                                loading == false;
                              });
                              snack(e.toString(), context);
                            }
                          },
                          child: Row(
                            children: [
                              loading
                                  ? SpinKitChasingDots(
                                      color: Theme.of(context).primaryColor,
                                      size: 12,
                                    )
                                  : Icon(
                                      Icons.logout,
                                      color: Theme.of(context).primaryColor,
                                      size: 12,
                                    ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Log Out",
                                style: textStyleText(context).copyWith(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
                bottom: TabBar(
                  indicatorColor: Theme.of(context).primaryColorLight,
                  indicatorWeight: 3,
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.image,
                        color: Theme.of(context).primaryColorLight,
                        size: 12,
                      ),
                      //text: "Images",
                    ),
                    Tab(
                      icon: Icon(Icons.text_fields_sharp,
                          size: 12, color: Theme.of(context).primaryColorLight),
                      //text: "Text",
                    ),
                    Tab(
                      icon: Icon(Icons.picture_as_pdf,
                          size: 12, color: Theme.of(context).primaryColorLight),
                      //text: "Text",
                    ),
                  ],
                ),
              ),
            ],
            body: DoubleBackToCloseApp(
              snackBar: SnackBar(
                backgroundColor: Theme.of(context).primaryColor.withOpacity(1),
                content: Text(
                  'Tap back again to leave the application',
                  style: TextStyle(color: Theme.of(context).primaryColorLight),
                  textAlign: TextAlign.center,
                ),
              ),
              child: TabBarView(
                children: [
                  //Tabs
                  LearnerViewAllMessages(loading: loading),
                  const LearnerViewAllTexts(),
                  const LearnerViewDocuments(),
                ],
              ),
            ),
          ),
        ));
  }

  //profile view
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
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LearnersProfile(),
                ),
              );
              logger.e(FirebaseAuth.instance.currentUser!.email);
            },
            child: Container(
              color: Theme.of(context).primaryColor.withOpacity(.80),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
              ),
              child: Column(
                children: [
                  user!.email != "" ||
                          user!.email!.isEmpty ||
                          user!.email != null
                      ? CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            user!.email.toString()[0].toUpperCase() ?? "",
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.8)),
                          ),
                        )
                      : CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                  const SizedBox(
                    height: 22,
                  ),
                  Wrap(children: [
                    learnersSecondName != ""
                        ? Text(
                            learnersSecondName.toString(),
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).primaryColorLight),
                          )
                        : CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                  ]),
                  const SizedBox(
                    height: 22,
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
                learnersEmail.toString(),
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).primaryColor),
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
          .then(
            (value) => logger.i("signed out"),
          )
          .whenComplete(
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Authenticate())),
          );
    } catch (e) {
      logger.i(e.toString());
    }
  }

  //get the field required for the current logged in user
  Future<void> _getCurrentUserFields(
    String nameOfLeaner,
    String secondNameOfLeaner,
    String emailOfLeaner,
  ) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    var userQuery =
        firestore.collection('learnersData').where('uid', isEqualTo: user!.uid);
    userQuery.get().then((var querySnapshot) {
      if (querySnapshot.size > 0) {
        var documentSnapshot = querySnapshot.docs.first;
        Map<String, dynamic>? data = documentSnapshot.data();

        //get the learners details
        nameOfLeaner = data['name'].toString();
        secondNameOfLeaner = data['secondName'].toString();
        emailOfLeaner = data['email'].toString();

        setState(() {
          learnersSecondName = secondNameOfLeaner.toString();
          learnersName = nameOfLeaner.toString();
          learnersEmail = emailOfLeaner.toString();
        });

        logger.i("inside getField $learnersEmail");
        logger.i("inside getField $learnersName\t$learnersSecondName");
      } else {
        Fluttertoast.showToast(msg: "Couldn't load data, internet interacted");
      }
    }).catchError((error) => print('Failed to get document: $error'));
  }
}
