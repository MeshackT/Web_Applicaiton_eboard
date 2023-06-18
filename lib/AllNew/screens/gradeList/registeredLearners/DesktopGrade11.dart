import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:yueway/AllNew/screens/Authentication/Authenticate.dart';
import 'package:yueway/AllNew/screens/Authentication/TeacherProfile.dart';
import 'package:yueway/AllNew/screens/gradeList/grade10.dart';
import 'package:yueway/AllNew/screens/gradeList/grade11.dart';
import 'package:yueway/AllNew/screens/gradeList/grade12.dart';
import 'package:yueway/AllNew/screens/gradeList/grade8.dart';
import 'package:yueway/AllNew/screens/gradeList/grade9.dart';
import 'package:yueway/AllNew/screens/gradeList/registeredLearners/NavigationDrawer.dart';
import 'package:yueway/AllNew/screens/more/more.dart';

import '../../../model/ConnectionChecker.dart';
import '../../../shared/constants.dart';
import '../../Notifications/sendNotification.dart';
import '../../home/AddEditMarksForAll.dart';
import '../../home/home.dart';

Logger logger = Logger(printer: PrettyPrinter(colors: true));
var user = FirebaseAuth.instance.currentUser;

//A Model to grab and store data
class RegisterLearner {
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

  //constructor
  RegisterLearner({
    required this.uid,
    required this.documentID,
    required this.name,
    required this.grade,
    required this.subject1,
    required this.learnersDocumentID,
    required this.term1Mark1,
    required this.term1Mark2,
    required this.term1Mark3,
    required this.term1Mark4,
    required this.term1Assignment1,
    required this.term1Assignment2,
    required this.term1Assignment3,
    required this.term1Assignment4,
    required this.exam1,
    required this.exam2,
  });

  CollectionReference userData =
      FirebaseFirestore.instance.collection('Grade12');

  //get current logged in user

  //Method for registering a learner
  Future<void> addLearner() {
    //get document ID
    final documentID = userData.id;

    // Call the user's CollectionReference to add a new user
    return userData
        .add({
          'uid': user!.uid,
          'documentID': documentID,
          'name': name,
          'subject': subject1,
          'grade': grade,
          'term1Mark1': term1Mark1,
          'term1Mark2': term1Mark2,
          'term1Mark3': term1Mark3,
          'term1Mark4': term1Mark4,
          'term1Assignment1': term1Assignment1,
          'term1Assignment2': term1Assignment2,
          'term1Assignment3': term1Assignment3,
          'term1Assignment4': term1Assignment4,
          'exam1': exam1,
          'exam2': exam2,
        })
        .then(
          (value) => print("Registered user"),
        )
        .catchError(
          (error) => logger.i("failed to add learner  $error"),
        );
  }
}

class DesktopGrade11 extends StatefulWidget {
  const DesktopGrade11({Key? key}) : super(key: key);
  static const routeName = '/grade12';

  @override
  State<DesktopGrade11> createState() => _DesktopGrade11State();
}

class _DesktopGrade11State extends State<DesktopGrade11> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = '';

  CollectionReference allLearnersCollection =
      FirebaseFirestore.instance.collection('learnersData');
  List<DocumentSnapshot> documents = [];

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

  List<String> passData = [];

  //var localList = [];

  CollectionReference userData =
      FirebaseFirestore.instance.collection('Grade12');
  final docId = FirebaseFirestore.instance.collection('Grade12').doc();

  bool isRegistered = false;
  String registered = "Not registration";
  bool loading = false;
  bool isVisible = false;

  String nameOfTeacher = "";
  String _userSubject = '';
  String _userSubject2 = '';

  @override
  void initState() {
    super.initState();
    ConnectionChecker.checkTimer();
    _getUserField();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void deleteSubject(String learnersDocumentID, String _userSubject) async {
    // Fetch the document
    DocumentSnapshot docSnapshot =
        await allLearnersCollection.doc(learnersDocumentID).get();

    // Get the allSubjects array
    var allSubjects = docSnapshot.get('allSubjects');

    // Remove the 'subject' key from the allSubjects object
    allSubjects.remove(_userSubject);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < Utils.mobileWidth) {
        return const Grade11();
      } else {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Registered learner's"),
            elevation: 0.0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SendNotification()));
                },
                icon: Icon(
                  Icons.notification_add,
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
            ],
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.only(top: 0.0),
            decoration: const BoxDecoration(
              //screen background color
              gradient: LinearGradient(
                  colors: [Color(0x0fffffff), Color(0xE7791971)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                const NavigationDrawerForALl(),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: TextField(
                          controller: _searchController,
                          cursorColor: Theme.of(context).primaryColorDark,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorLight,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            // enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            // disabledBorder: InputBorder.none,
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
                      //TODO add here
                      Expanded(
                        flex: 1,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: StreamBuilder(
                              stream: allLearnersCollection
                                  .where('teachersID', arrayContains: user!.uid)
                                  .where('grade', isEqualTo: '11')
                                  .orderBy('name', descending: true)
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
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                        ),
                                      ),
                                      SpinKitChasingDots(
                                        color:
                                            Theme.of(context).primaryColorDark,
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
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                        ),
                                      ),
                                      SpinKitChasingDots(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        size: 15,
                                      ),
                                    ],
                                  ));
                                } else if (streamSnapshot.hasError) {
                                  return Text("Error: ${streamSnapshot.error}");
                                } else if (!streamSnapshot.hasData ||
                                    streamSnapshot.data == null ||
                                    streamSnapshot.data!.size <= 0) {
                                  return Center(
                                    child: Text(
                                      "No list of grade 11 learners yet.",
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
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
                                                    "Remove the subject from this"
                                                    " learner or add marks for the learner",
                                                    context),
                                              ],
                                            ),
                                            trailing: SizedBox(
                                              width: 120,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  IconButton(
                                                    color: Colors.blue,
                                                    onPressed: () {
                                                      //show the dialog when you press delete
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              'Remove $_userSubject?',
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                            content: Text(
                                                              'This action will '
                                                              'permanently '
                                                              'delete all marks stored for'
                                                              ' $_userSubject for this learner, '
                                                              'are you sure you '
                                                              'want to delete?',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColorDark
                                                                      .withOpacity(
                                                                          .70)),
                                                            ),
                                                            actions: <Widget>[
                                                              Center(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    SizedBox(
                                                                      width:
                                                                          120,
                                                                      child:
                                                                          TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Cancel',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Theme.of(context).primaryColor,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          120,
                                                                      child:
                                                                          TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          //Delete the record
                                                                          final navContext =
                                                                              Navigator.of(context);
                                                                          var colorToast =
                                                                              Theme.of(context);

                                                                          try {
                                                                            //get the documents data from firestore
                                                                            DocumentSnapshot
                                                                                snapshot =
                                                                                await FirebaseFirestore.instance.collection('learnersData').doc(documents[index].id).get();

                                                                            if (snapshot.exists) {
                                                                              logger.e(snapshot.get("allSubjects"));

                                                                              // go to the field in the document
                                                                              var data = snapshot.get("allSubjects");

                                                                              // check if the data is a Map
                                                                              if (data is Map) {
                                                                                logger.e("is a map $_userSubject $_userSubject2");
                                                                                // check if the user subject exists in the Map
                                                                                if (data.containsKey(_userSubject)) {
                                                                                  var newIndex = data.containsKey(_userSubject).toString();
                                                                                  logger.i("this is the index $newIndex");
                                                                                  FirebaseFirestore.instance.collection('learnersData').doc(documents[index].id).update({
                                                                                    'allSubjects.$_userSubject': FieldValue.delete(),
                                                                                  });
                                                                                  Fluttertoast.showToast(backgroundColor: colorToast.primaryColor, msg: "Learner is de-registered from doing $_userSubject");
                                                                                  logger.i("deleted $_userSubject");
                                                                                  logger.e(snapshot.data());
                                                                                  navContext.pop();
                                                                                  setState(() {
                                                                                    isRegistered = true;
                                                                                    loading = false;
                                                                                  });
                                                                                  return;
                                                                                } else if (data.containsKey("$_userSubject2")) {
                                                                                  FirebaseFirestore.instance.collection('learnersData').doc(documents[index].id).update({
                                                                                    'allSubjects.$_userSubject2': FieldValue.delete(),
                                                                                  }).then((value) => Fluttertoast.showToast(msg: "deleted"));
                                                                                  logger.i("deleted $_userSubject2");
                                                                                  Fluttertoast.showToast(backgroundColor: colorToast.primaryColor, msg: "Learner is de-registered from doing $_userSubject2 Lit");
                                                                                  navContext.pop();
                                                                                  setState(() {
                                                                                    isRegistered = true;
                                                                                    loading = false;
                                                                                  });
                                                                                  return;
                                                                                } else {
                                                                                  Fluttertoast.showToast(backgroundColor: colorToast.primaryColor, msg: "There is no subject registered");
                                                                                  navContext.pop();
                                                                                }
                                                                              } else {
                                                                                logger.i("field is Not a map");
                                                                              }
                                                                            } else {
                                                                              // handle case where document does not exist
                                                                              logger.i('Document does not exist');
                                                                            }
                                                                          } catch (e) {
                                                                            logger.i(e);
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              SnackBar(
                                                                                content: Text(
                                                                                  'Failed to de-Register a learner ${e.toString()}',
                                                                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                                                ),
                                                                                backgroundColor: Colors.purple,
                                                                              ),
                                                                            );
                                                                            logger.i(documents[index][user!.uid]);
                                                                          }
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Yes',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Theme.of(context).primaryColor,
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
                                                    },
                                                    icon: Icon(
                                                      Icons.delete,
                                                      size: 25,
                                                      key: ValueKey(
                                                          documents[index]),
                                                      color:
                                                          IconTheme.of(context)
                                                              .color!
                                                              .withOpacity(.6),
                                                    ),
                                                  ),
                                                  InkWell(
                                                      child: SizedBox(
                                                        height: 40,
                                                        width: 40,
                                                        child: Icon(
                                                          Icons
                                                              .keyboard_double_arrow_right,
                                                          size: 25,
                                                          key: widget.key,
                                                          color: IconTheme.of(
                                                                  context)
                                                              .color!
                                                              .withOpacity(.7),
                                                        ),
                                                      ),
                                                      onTap: () async {
                                                        try {
                                                          snack(
                                                              "Loading Data please wait...",
                                                              context);

                                                          // get the document data from firestore
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

                                                          // check if the document exists
                                                          if (snapshot.exists) {
                                                            // get the allSubjects map from the document data
                                                            Map<String, dynamic>
                                                                data =
                                                                snapshot.get(
                                                                    "allSubjects");
                                                            // check if the data is a map
                                                            if (data is Map) {
                                                              bool
                                                                  foundCatIndex =
                                                                  false;
                                                              // for every key-value pair in the map
                                                              data.forEach(
                                                                  (key, value) {
                                                                // if the key is equal to _userSubject
                                                                if (key ==
                                                                    _userSubject) {
                                                                  // index is present
                                                                  foundCatIndex =
                                                                      true;
                                                                  Map<String,
                                                                          dynamic>
                                                                      finalMarks =
                                                                      {};
                                                                  // store the teacherSubject here
                                                                  var teacherSubject =
                                                                      value;

                                                                  finalMarks[
                                                                          _userSubject] =
                                                                      teacherSubject;
                                                                  String
                                                                      documentIDToEdit =
                                                                      documents[
                                                                              index]
                                                                          .id;
                                                                  logger.i(
                                                                      "$finalMarks\n$documentIDToEdit\n$_userSubject");
                                                                  Navigator.of(
                                                                          context)
                                                                      .pushReplacement(
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              AddEditForAll(
                                                                        getMarksFromFirestore:
                                                                            finalMarks,
                                                                        subjectName:
                                                                            _userSubject,
                                                                        documentIDToEdit:
                                                                            documentIDToEdit,
                                                                      ),
                                                                    ),
                                                                  );
                                                                  // do something with the 'CAT' data, such as print it
                                                                } else if (key ==
                                                                    _userSubject2) {
                                                                  // index is present
                                                                  foundCatIndex =
                                                                      true;
                                                                  Map<String,
                                                                          dynamic>
                                                                      finalMarks2 =
                                                                      {};
                                                                  // store the teacherSubject here
                                                                  var teacherSubject2 =
                                                                      value;

                                                                  finalMarks2[
                                                                          _userSubject2] =
                                                                      teacherSubject2;
                                                                  String
                                                                      documentIDToEdit =
                                                                      documents[
                                                                              index]
                                                                          .id;
                                                                  logger.i(
                                                                      "$finalMarks2\n$documentIDToEdit\n$_userSubject2");
                                                                  Navigator.of(
                                                                          context)
                                                                      .pushReplacement(
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              AddEditForAll(
                                                                        getMarksFromFirestore:
                                                                            finalMarks2,
                                                                        subjectName:
                                                                            _userSubject2,
                                                                        documentIDToEdit:
                                                                            documentIDToEdit,
                                                                      ),
                                                                    ),
                                                                  );
                                                                  // do something with the 'CAT' data, such as print it
                                                                }
                                                              });
                                                              // if the teacherSubject is not found
                                                              if (!foundCatIndex) {
                                                                // handle case where _userSubject index does not exist
                                                                logger.i(
                                                                    'No $_userSubject index found');
                                                                snack(
                                                                    "Leaner is not registered",
                                                                    context);
                                                              }
                                                            } else {
                                                              // handle case where teacherSubject index does not exist
                                                              logger.i(
                                                                  'No $_userSubject index found');
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          "$_userSubject not found");
                                                            }
                                                          } else {
                                                            // handle case where document does not exist
                                                            logger.i(
                                                                'Document does not exist');
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "No document found");
                                                          }
                                                          setState(() {
                                                            loading = false;
                                                          });
                                                        } catch (e) {
                                                          setState(() {
                                                            loading = false;
                                                          });
                                                          logger.i(e);
                                                          Fluttertoast
                                                              .showToast(
                                                            msg: e.toString(),
                                                            textColor: Theme.of(
                                                                    context)
                                                                .primaryColorLight,
                                                            backgroundColor:
                                                                Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                          );
                                                        }
                                                      }),
                                                ],
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
              ],
            ),
          ),
        );
      }
    });
  }

  //get the field required for the current logged in user
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
        _userSubject = data?['subjects'][0];
        _userSubject2 = data?['subjects'][1];

        nameOfTeacher = data?['name'];
        print('User subject: $_userSubject User Name: $nameOfTeacher');
      } else {
        print('No document found');
      }
    }).catchError((error) => print('Failed to get document: $error'));
  }

  getDataFromFirestore(String term1MarkOne, String term1MarkTwo,
      String term1MarkThree, String term1MarkFour) {
    term1Mark4 = term1MarkFour;
    term1Mark3 = term1MarkThree;
    term1Mark2 = term1MarkTwo;
    term1Mark1 = term1MarkOne;

    passData.add(term1Mark1);
    passData.add(term1Mark2);
    passData.add(term1Mark3);
    passData.add(term1Mark4);
  }
}

//drawer

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Container(
          color: Theme.of(context).primaryColorLight,
          width: MediaQuery.of(context).size.width / 3.8,
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
                        Icon(
                          Icons.person,
                          size: 18,
                          color: Theme.of(context).primaryColor,
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
                        teachersSecondName.toString(),
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
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const DesktopGrade11()));
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
          Fluttertoast.showToast(
              backgroundColor: Theme.of(context).primaryColor,
              msg: 'Could not log out, you are still signed in!');
        }
      });
    } catch (e) {
      Fluttertoast.showToast(
          backgroundColor: Theme.of(context).primaryColor,
          msg: 'Could not log out, you are still signed in!\n${e.toString()}');
    }
  }
}
