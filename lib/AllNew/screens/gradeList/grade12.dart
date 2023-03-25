import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';

import '../home/AddEditMarksForAll.dart';
import '../home/home.dart';

Logger logger = Logger(printer: PrettyPrinter(colors: true));

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
  User? user = FirebaseAuth.instance.currentUser;

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

class Grade12 extends StatefulWidget {
  const Grade12({Key? key}) : super(key: key);
  static const routeName = '/grade12';

  @override
  State<Grade12> createState() => _Grade12State();
}

class _Grade12State extends State<Grade12> {
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
  var localList = [];

  CollectionReference userData =
      FirebaseFirestore.instance.collection('Grade12');
  final docId = FirebaseFirestore.instance.collection('Grade12').doc();

  //get current logged in user
  User? user = FirebaseAuth.instance.currentUser;

  bool isRegistered = false;
  String registered = "Not registration";
  bool loading = false;
  bool isVisible = false;

  String nameOfTeacher = "";
  String _userSubject = '';

  @override
  void initState() {
    super.initState();
    _getUserField();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void deleteSubject(String learnersDocumentID, String _userSubject) async {
    // Fetch the document
    DocumentSnapshot docSnapshot =
        await allLearnersCollection.doc(learnersDocumentID).get();

    // Get the allSubjects array
    var allSubjects = docSnapshot.get('allSubjects');

    // Remove the 'CAT' key from the allSubjects object
    allSubjects.remove(_userSubject);

    // Update the document with the modified allSubjects array
    // learnersDataRef
    //     .doc('auto-generated-id')
    //     .update({'allSubjects': allSubjects});
  }

  @override
  Widget build(BuildContext context) {
    //disabled register button after registering learner
    void disableButton(int index) {
      setState(() {
        isRegistered = true;
      });
    }

    void toggleVisibility() {
      setState(() {
        isVisible = !isVisible;
      });
    }

    @override
    void dispose() {
      _searchController.dispose();
      super.dispose();
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Registered learners"),
          elevation: 0.0,
          centerTitle: true,
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
          child: Column(
            children: [
              isVisible
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: TextField(
                        controller: _searchController,
                        cursorColor: Colors.purple,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.purple, width: 1.0),
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
                          hintStyle: const TextStyle(
                              color: Colors.purple,
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
                    )
                  : const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Search for a learner",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.purple),
                      ),
                    ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: allLearnersCollection
                      .where('teachersID', arrayContains: user!.uid)
                      .snapshots(),
                  builder: (ctx, streamSnapshot) {
                    if (streamSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                          child: SpinKitChasingDots(
                        color: Colors.purple,
                      ));
                    }
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
                              color: Colors.purple.shade600,
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
                    documents = streamSnapshot.data!.docs;
                    //todo Documents list added to filterTitle
                    if (searchText.isNotEmpty) {
                      documents = documents.where((element) {
                        return element
                            .get('name')
                            .toString()
                            .toLowerCase()
                            .startsWith(searchText.toLowerCase());
                      }).toList();
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        documents = streamSnapshot.data!.docs;

                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              // const Text("A list of grade 12 Mathematics learners"),
                              ListTile(
                                leading: CircleAvatar(
                                  child: Text(documents[index]['name'][0]),
                                ),
                                title: Text(
                                  documents[index]['name'],
                                  style: const TextStyle(color: Colors.black),
                                ),
                                subtitle:
                                    Text("Grade " + documents[index]['grade']),
                                trailing: SizedBox(
                                  width: 120,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        color: Colors.blue,
                                        onPressed: isRegistered
                                            ? null
                                            : () async {
                                                try {
                                                  // Get the document data from Firestore
                                                  DocumentSnapshot snapshot =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'learnersData')
                                                          .doc(documents[index]
                                                              .id)
                                                          .get();

                                                  // Check if the document exists
                                                  if (snapshot.exists) {
                                                    // Go to the field in the document
                                                    List<dynamic> allSubjects =
                                                        snapshot
                                                            .get("allSubjects");

                                                    // Remove the desired item from the array
                                                    allSubjects.removeWhere(
                                                        (item) =>
                                                            item.containsKey(
                                                                _userSubject));

                                                    // Update the document in Firestore to save the modified array
                                                    await snapshot.reference
                                                        .update({
                                                      "allSubjects": allSubjects
                                                    }).then(
                                                      (value) =>
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              "Position $index $_userSubject removed"),
                                                          duration:
                                                              const Duration(
                                                                  seconds: 1),
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    // Handle case where document does not exist
                                                    logger.i(
                                                        'Document does not exist');
                                                  }
                                                } catch (e) {
                                                  logger.i(e);
                                                }
                                              },
                                        icon: loading
                                            ? SpinKitChasingDots(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 10,
                                              )
                                            : Icon(
                                                Icons.delete,
                                                size: 25,
                                                color: Colors.purple.shade200,
                                              ),
                                      ),
                                      InkWell(
                                        child: SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: loading
                                              ? SpinKitChasingDots(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: 10,
                                                )
                                              : Icon(
                                                  Icons
                                                      .keyboard_double_arrow_right,
                                                  size: 25,
                                                  key: widget.key,
                                                  color: Colors.purple,
                                                ),
                                        ),
                                        onTap: () async {
                                          // logger.i(documents[index]
                                          //     .get('allSubjects')[0]);
                                          // logger.i(documents[index]
                                          //     .get('allSubjects')[1]);

                                          // subjectMarks(documents[index].id,
                                          //     _userSubject);
                                          // final DocumentSnapshot doc =
                                          //     await FirebaseFirestore.instance
                                          //         .collection('learnersData')
                                          //         .doc(documents[index].id)
                                          //         .get();
                                          //
                                          // final List<dynamic> allSubjects =
                                          //     doc.get('allSubjects');
                                          //
                                          // // allSubjects.forEach((subjects) {
                                          // //   logger.i(subjects);
                                          // // });
                                          //
                                          // //this should be true
                                          // //check if the array contains $userSubject
                                          // bool containsMathematics = allSubjects
                                          //     .any((element) => element
                                          //         .containsKey(_userSubject));
                                          // logger.i(containsMathematics); //true
                                          ///////////////////////////////////////

                                          try {
                                            final DocumentReference
                                                documentRef = FirebaseFirestore
                                                    .instance
                                                    .collection('learnersData')
                                                    .doc(documents[index].id);

                                            // Get the document snapshot
                                            final DocumentSnapshot
                                                documentSnapshot =
                                                await documentRef.get();
                                            // Get the allSubjects array from
                                            // the document data
                                            final List<dynamic> allSubjects =
                                                documentSnapshot['allSubjects'];

                                            //get the documents data from firestore
                                            DocumentSnapshot snapshot =
                                                await FirebaseFirestore.instance
                                                    .collection('learnersData')
                                                    .doc(documents[index]
                                                        .id) // replace 'documentID' with the actual ID of the document
                                                    .get();

                                            //check if the document exits
                                            if (snapshot.exists) {
                                              //go to the field in the document
                                              var data =
                                                  snapshot.get(("allSubjects"));
                                              //check if the data is a List
                                              if (data is List) {
                                                bool foundCatIndex = false;
                                                //for every item in the list
                                                for (var item in data) {
                                                  //if the item is==$userSubject
                                                  if (item.containsKey(
                                                      _userSubject)) {
                                                    //index is present
                                                    foundCatIndex = true;
                                                    //get the teacher subject from the list
                                                    var teacherSubject =
                                                        item[_userSubject]["0"];
                                                    Map<String, dynamic>
                                                        finalMarks = {};

                                                    var teacherSub =
                                                        item[_userSubject];

                                                    //logger.i(teacherSub);
                                                    finalMarks[_userSubject] =
                                                        teacherSub;
                                                    String documentIDToEdit =
                                                        documents[index].id;

                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
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
                                                    break;
                                                  }
                                                }
                                                //if the teacherSubject is not found

                                                if (!foundCatIndex) {
                                                  // handle case where 'CAT' index does not exist
                                                  logger.i(
                                                      'No $_userSubject index found');
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'The learner is not registered to do $_userSubject'),
                                                    duration: const Duration(
                                                        seconds: 1),
                                                  ));
                                                }
                                                //check if the stored data is a Map
                                              } else if (data is Map &&
                                                  data.containsKey(
                                                      _userSubject)) {
                                                //store the teacherSubject here
                                                var teacherSubject =
                                                    data[_userSubject];
                                                // do something with the 'CAT' data, such as print it
                                                logger.i(teacherSubject);
                                              } else {
                                                // handle case where teacherSubject index does not exist
                                                logger.i(
                                                    'No $_userSubject index found');
                                              }
                                            } else {
                                              // handle case where document does not exist
                                              logger
                                                  .i('Document does not exist');
                                            }
                                          } catch (e) {
                                            logger.i(e);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: toggleVisibility,
          child: const Icon(Icons.search),
        ));
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
