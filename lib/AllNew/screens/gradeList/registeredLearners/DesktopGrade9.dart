import 'package:Eboard/AllNew/screens/Authentication/Authenticate.dart';
import 'package:Eboard/AllNew/screens/gradeList/grade9.dart';
import 'package:Eboard/AllNew/screens/gradeList/registeredLearners/NavigationDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

import '../../../model/ConnectionChecker.dart';
import '../../../shared/constants.dart';
import '../../Notifications/sendNotification.dart';
import '../../home/AddEditMarksForAll.dart';
import 'DetailedMarks.dart';

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

class DesktopGrade9 extends StatefulWidget {
  const DesktopGrade9({Key? key}) : super(key: key);
  static const routeName = '/grade12';

  @override
  State<DesktopGrade9> createState() => _DesktopGrade9State();
}

class _DesktopGrade9State extends State<DesktopGrade9> {
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
  bool showMarks = false;
  bool showMarks2 = false;

  var indexList = {};
  String nameParse = "";

  String nameOfTeacher = "";
  String _userSubject = '';
  String _userSubject2 = "";

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

  Future<void> selectedItem(
    BuildContext context,
    item,
    int selectedItemI,
    String documentsIndexId,
    String nameOfLearner,
  ) async {
    switch (item) {
      case 0:
        break;
      case 1:
        //Register the first  subject
        enterMarksForSubjectOne(selectedItemI, documentsIndexId, nameOfLearner);
        break;
      case 2:
        //Register the second subject
        enterMarksForSubjectTwo(selectedItemI, documentsIndexId, nameOfLearner);
        break;
      case 3:
        break;
      case 4:
        //delete subject one
        deleteSubjectOne(documentsIndexId);
        break;
      case 5:
        //delete subject two
        deleteSubjectTwo(documentsIndexId);
        break;
    }
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
        return const Grade9();
      } else {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Grade 9 registered learner's",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 2,
              ),
            ),
            elevation: 0.0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
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
                NavigationDrawerForALl(nameOfTeacher: nameOfTeacher),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 3.0,
                        )
                      ],
                    ),
                    margin: const EdgeInsets.only(right: 10),
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
                          flex: 2,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: StreamBuilder(
                                stream: allLearnersCollection
                                    .where('teachersID',
                                        arrayContains: user!.uid)
                                    .where('grade', isEqualTo: '9')
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
                                          color: Theme.of(context)
                                              .primaryColorDark,
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
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          size: 15,
                                        ),
                                      ],
                                    ));
                                  } else if (streamSnapshot.hasError) {
                                    return Text(
                                        "Error: ${streamSnapshot.error}");
                                  } else if (!streamSnapshot.hasData ||
                                      streamSnapshot.data == null ||
                                      streamSnapshot.data!.size <= 0) {
                                    return Center(
                                      child: Text(
                                        "No list of grade 9 learners yet.",
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: documents.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      String nameOfL = documents[index]['name'];
                                      String surnameOfL =
                                          documents[index]['secondName'];
                                      String gradeOfL =
                                          documents[index]['grade'];
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
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColorDark,
                                                child: Text(
                                                  nameOfL[0],
                                                ),
                                              ),
                                              title: Text(
                                                nameOfL,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                ),
                                              ),
                                              subtitle: ExpansionTile(
                                                childrenPadding:
                                                    const EdgeInsets.only(
                                                        bottom: 10),
                                                collapsedIconColor:
                                                    Colors.green.shade900,
                                                iconColor:
                                                    Colors.green.shade900,
                                                title: Row(
                                                  children: [
                                                    Text(
                                                      "View Marks",
                                                      style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorDark,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    Utils.toolTipMessage(
                                                        "View / Remove subject from this"
                                                        " learner's database",
                                                        context),
                                                  ],
                                                ),
                                                maintainState: false,
                                                expandedCrossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                expandedAlignment:
                                                    Alignment.centerLeft,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            bottom: 20),
                                                    child: Text(
                                                      "Grade  $gradeOfL",
                                                      style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorDark,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      if (showMarks == true ||
                                                          showMarks2 == true) {
                                                        setState(() {
                                                          showMarks = false;
                                                          showMarks2 = false;
                                                        });
                                                        logger.i(
                                                            "My name first $nameOfL");
                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                            () async =>
                                                                await viewMarksForSubjectOne(
                                                                  index,
                                                                  documents[
                                                                          index]
                                                                      .id,
                                                                  nameOfL,
                                                                ));
                                                      }
                                                      if (showMarks == false ||
                                                          showMarks2 == false) {
                                                        logger.i(
                                                            "My name first $nameOfL");
                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                            () async =>
                                                                await viewMarksForSubjectOne(
                                                                  index,
                                                                  documents[
                                                                          index]
                                                                      .id,
                                                                  nameOfL,
                                                                ));
                                                      }
                                                    },
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 20,
                                                                bottom: 10),
                                                        child:
                                                            _userSubject.isEmpty
                                                                ? Text(
                                                                    "1st Subject",
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .primaryColorDark,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  )
                                                                : Text(
                                                                    "View ${_userSubject.capitalize()}",
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .primaryColorDark,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                  )),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      if (showMarks == true ||
                                                          showMarks2 == true) {
                                                        setState(() {
                                                          showMarks = false;
                                                          showMarks2 = false;
                                                        });
                                                        logger.i(
                                                            "My name first $nameOfL");
                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                            () async =>
                                                                await viewMarksForSubjectTwo(
                                                                  index,
                                                                  documents[
                                                                          index]
                                                                      .id,
                                                                  nameOfL,
                                                                ));
                                                      }
                                                      if (showMarks == false ||
                                                          showMarks2 == false) {
                                                        logger.i(
                                                            "My name first $nameOfL");
                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                            () async =>
                                                                await viewMarksForSubjectTwo(
                                                                  index,
                                                                  documents[
                                                                          index]
                                                                      .id,
                                                                  nameOfL,
                                                                ));
                                                      }
                                                    },
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 20,
                                                                bottom: 10),
                                                        child:
                                                            _userSubject2
                                                                    .isEmpty
                                                                ? Text(
                                                                    "2nd Subject",
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .primaryColorDark,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  )
                                                                : Text(
                                                                    "View ${_userSubject2.capitalize()}",
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .primaryColorDark,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                  )),
                                                  ),
                                                ],
                                              ),
                                              trailing: SizedBox(
                                                width: 40,
                                                child: SizedBox(
                                                  width: 40,
                                                  height: 40,
                                                  child: PopupMenuButton<int>(
                                                    color: Theme.of(context)
                                                        .primaryColorLight,
                                                    icon: Icon(
                                                      Icons.more_vert,
                                                      color: Theme.of(context)
                                                          .iconTheme
                                                          .color,
                                                    ),
                                                    elevation: 5.0,
                                                    itemBuilder: (context) => [
                                                      PopupMenuItem<int>(
                                                        value: 0,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "Enter Marks",
                                                              style: textStyleText(context).copyWith(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      1,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      PopupMenuItem<int>(
                                                        value: 1,
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .double_arrow,
                                                              color: Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color,
                                                            ),
                                                            const SizedBox(
                                                              width: 7,
                                                            ),
                                                            _userSubject != ""
                                                                ? Text(
                                                                    _userSubject
                                                                        .capitalize(),
                                                                    style: textStyleText(context).copyWith(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                  )
                                                                : Text(
                                                                    "No 1st Subject",
                                                                    style: textStyleText(context).copyWith(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                  ),
                                                          ],
                                                        ),
                                                      ),
                                                      PopupMenuItem<int>(
                                                        value: 2,
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .double_arrow,
                                                              color: Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color,
                                                            ),
                                                            const SizedBox(
                                                              width: 7,
                                                            ),
                                                            _userSubject2 != ""
                                                                ? Text(
                                                                    _userSubject2
                                                                        .capitalize(),
                                                                    style: textStyleText(context).copyWith(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                  )
                                                                : Text(
                                                                    "No 2st Subject",
                                                                    style: textStyleText(context).copyWith(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                  ),
                                                          ],
                                                        ),
                                                      ),
                                                      PopupMenuItem<int>(
                                                        value: 3,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      15.0),
                                                          child: Divider(
                                                            height: 1,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark
                                                                .withOpacity(
                                                                    .7),
                                                          ),
                                                        ),
                                                      ),
                                                      PopupMenuItem<int>(
                                                        value: 4,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "Delete subjects",
                                                              style: textStyleText(context).copyWith(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      1,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      PopupMenuItem<int>(
                                                        value: 5,
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.delete,
                                                              color: Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color!
                                                                  .withOpacity(
                                                                      .7),
                                                            ),
                                                            const SizedBox(
                                                              width: 7,
                                                            ),
                                                            Text(
                                                              "Remove ${_userSubject.capitalize()}",
                                                              style: textStyleText(context).copyWith(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      PopupMenuItem<int>(
                                                        value: 5,
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.delete,
                                                              color: Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color!
                                                                  .withOpacity(
                                                                      .7),
                                                            ),
                                                            const SizedBox(
                                                              width: 7,
                                                            ),
                                                            Text(
                                                              "Remove ${_userSubject2.capitalize()}",
                                                              style: textStyleText(context).copyWith(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                    onSelected: (item) =>
                                                        selectedItem(
                                                            context,
                                                            item,
                                                            index,
                                                            documents[index].id,
                                                            nameOfL),
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
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: showMarks == false ? false : true,
                  child: DetailedMarks(
                      subjectName: _userSubject,
                      nameOfL: nameParse,
                      indexMarks: indexList),
                ),
                Visibility(
                  visible: showMarks2 == false ? false : true,
                  child: DetailedMarks(
                      subjectName: _userSubject2,
                      nameOfL: nameParse,
                      indexMarks: indexList),
                )
              ],
            ),
          ),
        );
      }
    });
  }

  // delete subject One
  Future<void> deleteSubjectOne(String documentsIndexId) async {
    //Delete the record
    final navContext = Navigator.of(context);
    var colorToast = Theme.of(context);

    try {
      //get the documents data from firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('learnersData')
          .doc(documentsIndexId)
          .get();

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
            FirebaseFirestore.instance
                .collection('learnersData')
                .doc(documentsIndexId)
                .update({
              'allSubjects.$_userSubject': FieldValue.delete(),
            });
            Fluttertoast.showToast(
                backgroundColor: colorToast.primaryColor,
                msg: "Learner is de-registered from doing $_userSubject");
            logger.i("deleted $_userSubject");
            logger.e(snapshot.data());
            setState(() {
              isRegistered = true;
              loading = false;
            });
            return;
          } else {
            Fluttertoast.showToast(
                backgroundColor: colorToast.primaryColor,
                msg: "There is no subject registered");
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
      // logger.i(documents[index][user!.uid]);
    }
  }

  // delete subject One
  Future<void> deleteSubjectTwo(String documentsIndexId) async {
    //Delete the record
    final navContext = Navigator.of(context);
    var colorToast = Theme.of(context);

    try {
      //get the documents data from firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('learnersData')
          .doc(documentsIndexId)
          .get();

      if (snapshot.exists) {
        logger.e(snapshot.get("allSubjects"));

        // go to the field in the document
        var data = snapshot.get("allSubjects");

        // check if the data is a Map
        if (data is Map) {
          logger.e("is a map $_userSubject $_userSubject2");

          if (data.containsKey(_userSubject2)) {
            FirebaseFirestore.instance
                .collection('learnersData')
                .doc(documentsIndexId)
                .update({
              'allSubjects.$_userSubject2': FieldValue.delete(),
            }).then((value) => Fluttertoast.showToast(msg: "deleted"));
            logger.i("deleted $_userSubject2");
            Fluttertoast.showToast(
                backgroundColor: colorToast.primaryColor,
                msg: "Learner is de-registered from doing $_userSubject2 Lit");
            setState(() {
              isRegistered = true;
              loading = false;
            });
            return;
          } else {
            Fluttertoast.showToast(
                backgroundColor: colorToast.primaryColor,
                msg: "There is no subject registered");
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
      // logger.i(documents[index][user!.uid]);
    }
  }

  //Register the first subject
  Future<void> enterMarksForSubjectOne(
    int selectedItemI,
    String documentsIndexId,
    String nameOfLearner,
  ) async {
    try {
      snack("Loading Data please wait...", context);

      // get the document data from firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('learnersData')
          // .doc(documents[index].id)
          .doc(documentsIndexId)
          .get();

      // check if the document exists
      if (snapshot.exists) {
        // get the allSubjects map from the document data
        Map<String, dynamic> data = snapshot.get("allSubjects");
        // check if the data is a map
        if (data is Map) {
          bool foundCatIndex = false;
          // for every key-value pair in the map
          data.forEach((key, value) {
            // if the key is equal to _userSubject
            if (key == _userSubject) {
              // index is present
              foundCatIndex = true;
              Map<String, dynamic> finalMarks = {};
              // store the teacherSubject here
              var teacherSubject = value;

              finalMarks[_userSubject] = teacherSubject;
              String
                  // documentIDToEdit = documents[index].id;
                  documentIDToEdit = documentsIndexId;
              logger.i("$finalMarks\n$documentIDToEdit\n$_userSubject");
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddEditForAll(
                    nameOfLearnerFromFirebase: nameOfLearner,
                    getMarksFromFirestore: finalMarks,
                    subjectName: _userSubject,
                    documentIDToEdit: documentIDToEdit,
                  ),
                ),
              );
              // do something with the 'CAT' data, such as print it
            }
          });
          // if the teacherSubject is not found
          if (!foundCatIndex) {
            // handle case where _userSubject index does not exist
            logger.i('No $_userSubject index found');
            snack(
                "Learner is not registered to do ${_userSubject.capitalize()}",
                context);
          }
        } else {
          // handle case where teacherSubject index does not exist
          logger.i('No $_userSubject index found');
          Fluttertoast.showToast(msg: "$_userSubject not found");
        }
      } else {
        // handle case where document does not exist
        logger.i('Document does not exist');
        Fluttertoast.showToast(msg: "No document found");
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      logger.i(e);
      Fluttertoast.showToast(
        msg: e.toString(),
        textColor: Theme.of(context).primaryColorLight,
        backgroundColor: Theme.of(context).primaryColor,
      );
    }
  }

  //Register the second subject
  Future<void> enterMarksForSubjectTwo(
    int selectedItemI,
    String documentsIndexId,
    String nameOfLearner,
  ) async {
    try {
      snack("Loading Data please wait...", context);

      // get the document data from firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('learnersData')
          // .doc(documents[index].id)
          .doc(documentsIndexId)
          .get();

      // check if the document exists
      if (snapshot.exists) {
        // get the allSubjects map from the document data
        Map<String, dynamic> data = snapshot.get("allSubjects");
        // check if the data is a map
        if (data is Map) {
          bool foundCatIndex = false;
          // for every key-value pair in the map
          data.forEach((key, value) {
            if (key == _userSubject2) {
              // index is present
              foundCatIndex = true;
              Map<String, dynamic> finalMarks2 = {};
              // store the teacherSubject here
              var teacherSubject2 = value;

              finalMarks2[_userSubject2] = teacherSubject2;
              String
                  // documentIDToEdit = documents[index].id;
                  documentIDToEdit = documentsIndexId;
              logger.i("$finalMarks2\n$documentIDToEdit\n$_userSubject2");
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => AddEditForAll(
                    nameOfLearnerFromFirebase: nameOfLearner,
                    getMarksFromFirestore: finalMarks2,
                    subjectName: _userSubject2,
                    documentIDToEdit: documentIDToEdit,
                  ),
                ),
              );
              // do something with the 'CAT' data, such as print it
            }
          });
          // if the teacherSubject is not found
          if (!foundCatIndex) {
            // handle case where _userSubject index does not exist
            logger.i('No $_userSubject2 index found');
            snack(
                "Learner is not registered to do ${_userSubject2.capitalize()}",
                context);
          }
        } else {
          // handle case where teacherSubject index does not exist
          logger.i('No $_userSubject index found');
          Fluttertoast.showToast(msg: "$_userSubject not found");
        }
      } else {
        // handle case where document does not exist
        logger.i('Document does not exist');
        Fluttertoast.showToast(msg: "No document found");
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      logger.i(e);
      Fluttertoast.showToast(
        msg: e.toString(),
        textColor: Theme.of(context).primaryColorLight,
        backgroundColor: Theme.of(context).primaryColor,
      );
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
          // uidOfTeacher = data['documentID'].toString();
          // teachersName = nameOfTeacherForDrawer.toString();
          // teachersSecondName = secondNameOfTeacherForDrawer.toString();
          // teachersEmail = emailOfTeacherForDrawer.toString();
          // teachersGrade = gradeOfTeacherDrawer.toString();
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

  Future<void> viewMarksForSubjectOne(
    int selectedItemI,
    String documentsIndexId,
    String nameOfL,
  ) async {
    try {
      // String nameOfLea = snapshot.get("name");

      // get the document data from firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('learnersData')
          // .doc(documents[index].id)
          .doc(documentsIndexId)
          .get();

      // check if the document exists
      if (snapshot.exists) {
        // get the allSubjects map from the document data
        var data = await snapshot.get("allSubjects");
        snack("Loading Data please wait...", context);
        // check if the data is a map
        if (data is Map) {
          bool foundCatIndex = false;
          // for every key-value pair in the map
          data.forEach((key, value) {
            // if the key is equal to _userSubject
            if (key == _userSubject) {
              setState(() {
                showMarks = true;
                showMarks2 = false;
              });
              // index is present
              foundCatIndex = true;
              var finalMarks = {};
              // store the teacherSubject here
              var teacherSubject = value;

              finalMarks[_userSubject] = teacherSubject;

              setState(() {
                indexList = finalMarks;
                nameParse = nameOfL;
              });
              logger.i("$showMarks and $showMarks2 $_userSubject");
            } else {
              Utils.logger.i("$showMarks and $showMarks2 $_userSubject");
            }
          });
          // if the teacherSubject is not found
          if (!foundCatIndex) {
            setState(() {
              showMarks = false;
              showMarks2 = false;
            });
            // handle case where _userSubject index does not exist
            logger.i('No $_userSubject index found');
            snack(
                "Learner is not registered to do ${_userSubject.capitalize()}",
                context);
          }
        } else {
          // handle case where teacherSubject index does not exist
          logger.i('No $_userSubject index found');
          Fluttertoast.showToast(msg: "$_userSubject not found");
        }
      } else {
        // handle case where document does not exist
        logger.i('Document does not exist');
        Fluttertoast.showToast(msg: "No marks found / not registered");
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      logger.i(e);
      Fluttertoast.showToast(
        msg: e.toString(),
        textColor: Theme.of(context).primaryColorLight,
        backgroundColor: Theme.of(context).primaryColor,
      );
    }
  }

  Future<void> viewMarksForSubjectTwo(
    int selectedItemI,
    String documentsIndexId,
    String nameOfL,
  ) async {
    try {
      // String nameOfLea = snapshot.get("name");

      // get the document data from firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('learnersData')
          // .doc(documents[index].id)
          .doc(documentsIndexId)
          .get();

      // check if the document exists
      if (snapshot.exists) {
        // get the allSubjects map from the document data
        var data = await snapshot.get("allSubjects");
        snack("Loading Data please wait...", context);
        // check if the data is a map
        if (data is Map) {
          bool foundCatIndex = false;
          // for every key-value pair in the map
          data.forEach((key, value) {
            // if the key is equal to _userSubject
            if (key == _userSubject2) {
              setState(() {
                showMarks2 = true;
                showMarks = false;
              });
              // index is present
              foundCatIndex = true;
              var finalMarks = {};
              // store the teacherSubject here
              var teacherSubject = value;

              finalMarks[_userSubject2] = teacherSubject;

              setState(() {
                indexList = finalMarks;
                nameParse = nameOfL;
              });
              logger.i("My name $nameOfL \nMy List here \n$indexList");
            } else {}
          });
          // if the teacherSubject is not found
          if (!foundCatIndex) {
            setState(() {
              showMarks = false;
              showMarks2 = false;
            });
            // handle case where _userSubject index does not exist
            logger.i('No $_userSubject2 index found');
            snack(
                "Learner is not registered to do ${_userSubject2.capitalize()}",
                context);
          }
        } else {
          // handle case where teacherSubject index does not exist
          logger.i('No $_userSubject index found');
          Fluttertoast.showToast(msg: "$_userSubject2 not found");
        }
      } else {
        // handle case where document does not exist
        logger.i('Document does not exist');
        Fluttertoast.showToast(msg: "No marks found / not registered");
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      logger.i(e);
      Fluttertoast.showToast(
        msg: e.toString(),
        textColor: Theme.of(context).primaryColorLight,
        backgroundColor: Theme.of(context).primaryColor,
      );
    }
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
        setState(() {
          _userSubject = data?['subjects'][0] ?? '';
          _userSubject2 = data?['subjects'][1] ?? '';
          nameOfTeacher = data?['name'] ?? '';
        });
        print(
            'User subjects: $_userSubject and $_userSubject2, User Name: $nameOfTeacher');
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
