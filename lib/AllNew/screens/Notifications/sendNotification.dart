import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:levy/AllNew/screens/gradeList/grade12.dart';
import 'package:levy/AllNew/screens/home/home.dart';
import 'package:levy/AllNew/shared/constants.dart';

import 'ViewNotification.dart';

User? user = FirebaseAuth.instance.currentUser;

//A Model to grab and store data
class UserFeeds {
  final String grade;
  final String uid;
  final String subject;
  final String name;
  final String documentID;
  final String description;
  final String title;
  final String date;

  UserFeeds(
    this.uid,
    this.grade,
    this.name,
    this.documentID,
    this.subject,
    this.description,
    this.title,
    this.date,
  );

  //collection reference
  final userFeeds = FirebaseFirestore.instance.collection('feeds').doc();

  //add the feed created to feed
  Future<void> addFeed() {
    //get document ID
    final documentID = userFeeds.id;
    //date
    Timestamp timeStamp = Timestamp.now();
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);

    // Call the user's CollectionReference to add a new user
    return userFeeds
        .set({
          'documentID': documentID, //document auto generated
          'uid': user!.uid, // The teacherID
          'name': name, //name of teacher
          'subject': subject, // subject name
          'grade': grade, //grade
          'title': title, // subject title
          'description': description, // subject description
          'time': FieldValue.serverTimestamp(),
        })
        .then((value) => print("feed entered"))
        .catchError((error) => print("Failed to add feed: $error"));
  }
}
//=====================================================================

class SendNotification extends StatefulWidget {
  const SendNotification({Key? key}) : super(key: key);
  static const routeName = '/select';

  @override
  State<SendNotification> createState() => _SendNotificationState();
}

class _SendNotificationState extends State<SendNotification> {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  // final FirebaseMessagingService _firebaseMessagingService =
  //     FirebaseMessagingService();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _grade = TextEditingController();
  final _subject = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String nameOfTeacher = "";
  String _userSubject = '';

  @override
  void initState() {
    super.initState();
    _getUserField();
    // _firebaseMessagingService.configureFirebaseMessaging();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              navigate(context);
            },
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          title: const Text("My Notifications"),
          titleSpacing: 2,
          centerTitle: false,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Home()));
              },
              icon: Icon(
                Icons.home,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ],
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColorLight,
            indicatorWeight: 2,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.create,
                  color: Theme.of(context).primaryColorLight,
                  size: 15,
                ),
                text: "Create",
              ),
              Tab(
                icon: Icon(Icons.mark_chat_unread,
                    size: 15, color: Theme.of(context).primaryColorLight),
                text: "View",
              ),
            ],
          ),
        ),
        extendBodyBehindAppBar: false,
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
              //Tabs/Terms
              buildPage("Create a Notification"),
              ViewNotifications(
                  subjectOfTeacherPassed: _userSubject.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPage(String title) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          //screen background color
          gradient: LinearGradient(
              colors: [Color(0x00cccccc), Color(0xE7791971)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              title,
              style: textStyleText(context)
                  .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: _titleController,
                          decoration: textInputDecoration.copyWith(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: .8,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            label: Text(
                              'About',
                              style: textStyleText(context).copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            hintText: "About message",
                            hintStyle: textStyleText(context),
                          ),
                          textAlign: TextAlign.center,
                          cursorColor: Theme.of(context).primaryColor,
                          cursorWidth: 2,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Message about what?";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: textInputDecoration.copyWith(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            label: Text(
                              "Your Message",
                              style: textStyleText(context).copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: "Enter your message here",
                            hintStyle: textStyleText(context),
                          ),
                          cursorColor: Theme.of(context).primaryColor,
                          cursorWidth: 2,
                          autocorrect: true,
                          textAlign: TextAlign.center,
                          maxLines: 6,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "enter your message";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: _subject,
                          decoration: textInputDecoration.copyWith(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.purple, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            label: Text(
                              "Your Subject",
                              style: textStyleText(context).copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: "Enter your subject here",
                            hintStyle: textStyleText(context),
                          ),
                          cursorColor: Theme.of(context).primaryColor,
                          cursorWidth: 2,
                          autocorrect: true,
                          textAlign: TextAlign.center,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "enter your subject";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: _grade,
                          decoration: textInputDecoration.copyWith(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: .8,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: .8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            label: Text(
                              "Your Grade",
                              style: textStyleText(context).copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: "Enter your grade here",
                            hintStyle: textStyleText(context),
                          ),
                          keyboardType: TextInputType.number,
                          cursorColor: Theme.of(context).primaryColor,
                          cursorWidth: 2,
                          autocorrect: true,
                          textAlign: TextAlign.center,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "enter your grade";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        OutlinedButton(
                          onPressed: () async {
                            String userLoggedIn = user!.uid;
                            String documentID = "";
                            String nameOfTeacherInput = nameOfTeacher;
                            String subjectOfTeacher = _subject.text;
                            String date = "";

                            if (_formKey.currentState!.validate()) {
                              final title = _titleController.text;
                              final description = _descriptionController.text;

                              //await FcmApi.sendNotification(title, description);

                              UserFeeds userFeeds = UserFeeds(
                                  userLoggedIn,
                                  _grade.text,
                                  nameOfTeacherInput.toString(),
                                  documentID,
                                  subjectOfTeacher,
                                  _descriptionController.text,
                                  _titleController.text,
                                  date);
                              userFeeds
                                  .addFeed()
                                  .then(
                                    (value) => print("added"),
                                  )
                                  .whenComplete(() =>
                                      snack("Notification sent", context));
                              _titleController.clear();
                              _grade.clear();
                              _descriptionController.clear();
                            }
                          },
                          style: buttonRound,
                          child: Text(
                            "Send",
                            style: textStyleText(context).copyWith(
                                color: Theme.of(context).primaryColorLight,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  //get the field required for the current logged in user
  Future<void> _getUserField() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    Query<Map<String, dynamic>> userQuery =
        firestore.collection('userData').where('uid', isEqualTo: user!.uid);
    userQuery.get().then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      if (querySnapshot.size > 0) {
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            querySnapshot.docs.first;
        Map<String, dynamic>? data = documentSnapshot.data();
        _userSubject = data?['subjects'][0] ?? '';
        // get the name field or empty string if it doesn't exist
        nameOfTeacher = data?['name'] ?? '';
        setState(() {
          _subject.text = _userSubject.toString();
        });
        print(
            'News Feed User subject: $_userSubject User Name: $nameOfTeacher');
      } else {
        print('No document found');
      }
    }).catchError((error) => print('Failed to get document: $error'));
  }
}

//Navigate to the previous page
Future navigate(BuildContext context) {
  return Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const Grade12()));
}
