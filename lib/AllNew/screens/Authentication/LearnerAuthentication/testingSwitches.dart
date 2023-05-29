import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yueway/AllNew/screens/Notifications/local_notifications.dart';

Logger logger = Logger(printer: PrettyPrinter(colors: true));
var user = FirebaseAuth.instance.currentUser!;
LocalNotificationService localNotificationService = LocalNotificationService();

class TeacherListPage extends StatefulWidget {
  List<dynamic> teachersIDS;
  TeacherListPage({Key? key, required this.teachersIDS}) : super(key: key);

  @override
  _TeacherListPageState createState() => _TeacherListPageState();
}

class _TeacherListPageState extends State<TeacherListPage> {
  List<String> teachersID = ["a", "B"];
  List<bool> switchValues = [];
  List<bool> switchValuess = [];

  List<dynamic> teachersIDS = []; // carries the ids of the teachers
  List<dynamic> subjectOfLearner = [];

  @override
  void initState() {
    super.initState();
    logger.e(widget.teachersIDS.length);
    setState(() {
      widget.teachersIDS.length;
    });
    // _getCurrentUserFieldsSubscriptions();
    //switchValues = List.generate(teachersID.length, (index) => false);
    switchValuess = List.generate(widget.teachersIDS.length, (index) => false);
    loadSwitchStates();
  }

  void toggleSwitch(int index, bool value) {
    setState(() {
      //switchValues[index] = value;
      switchValuess[index] = value;
    });

    saveSwitchState(index, value);

    final teacherID = widget.teachersIDS[index];
    if (value) {
      localNotificationService.subscribeToTopicDevice(teacherID);
      Fluttertoast.showToast(
          backgroundColor: Theme.of(context).primaryColor,
          msg: "Subscribed to $teacherID");
    } else {
      localNotificationService.unSubscribeToTopicDevice(teacherID);
      Fluttertoast.showToast(
          backgroundColor: Theme.of(context).primaryColor, msg: "Unsubscribed");
    }
  }

  Future<void> loadSwitchStates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // for (int i = 0; i < teachersID.length; i++) {
      //   switchValues[i] = prefs.getBool(teachersID[i]) ?? false;
      // }
      for (int i = 0; i < widget.teachersIDS.length; i++) {
        switchValuess[i] = prefs.getBool(widget.teachersIDS[i]) ?? false;
      }
    });
  }

  Future<void> saveSwitchState(int index, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //await prefs.setBool(teachersID[index], value);
    await prefs.setBool(widget.teachersIDS[index], value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teachers List'),
      ),
      body: Column(
        children: [
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: teachersID.length,
          //     itemBuilder: (BuildContext context, int index) {
          //       return ListTile(
          //         title: Text('Teacher ID: ${teachersID[index]}'),
          //         trailing: Switch(
          //           value: switchValues[index],
          //           onChanged: (value) {
          //             setState(() {
          //               switchValues[index] = value;
          //               saveSwitchState(index, value);
          //               print(switchValues[index]);
          //             });
          //           },
          //         ),
          //       );
          //     },
          //   ),
          // ),
          TextButton(
            onPressed: () {
              logger.i(widget.teachersIDS.length);
              logger.i(widget.teachersIDS[1]);
              logger.i(widget.teachersIDS[2]);
              logger.i(widget.teachersIDS[3]);
            },
            child: Text("Get the length of data"),
          ),
          const Divider(
            color: Colors.red,
            height: 5,
          ),
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.only(top: 15),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: ListView.builder(
                  physics: const ScrollPhysics(parent: null),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Switch(
                        value: switchValuess[index],
                        onChanged: (value) {
                          //toggleSwitch(index, value);

                          if (switchValuess[index] = value) {
                            localNotificationService.subscribeToTopicDevice(
                                widget.teachersIDS[index]);
                            Fluttertoast.showToast(msg: "subscribed");
                          } else {
                            localNotificationService.unSubscribeToTopicDevice(
                                widget.teachersIDS[index]);
                            Fluttertoast.showToast(msg: "unsubscribed");
                          }
                          logger.e("true or false => "
                              "${switchValuess[index]} $value");
                          setState(() {
                            switchValuess[index] = value;
                            saveSwitchState(index, value);
                            print("${switchValuess[index]} "
                                "${widget.teachersIDS[index]}");
                          });
                        },
                      ),
                      title: Text(widget.teachersIDS[index]),
                    );
                  },
                  itemCount: widget.teachersIDS.length,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
/*
Logger logger = Logger(printer: PrettyPrinter(colors: true));
var user = FirebaseAuth.instance.currentUser!;

class SubjectNotifications extends StatefulWidget {
  const SubjectNotifications({Key? key}) : super(key: key);

  @override
  State<SubjectNotifications> createState() => _SubjectNotificationsState();
}

class _SubjectNotificationsState extends State<SubjectNotifications> {
  List<dynamic> teachersIDS = [];
  List<dynamic> subjectNames = [];
  List<bool> switchValues = [];

  LocalNotificationService localNotificationService =
      LocalNotificationService();
  // bool setOn = false;

  @override
  void initState() {
    super.initState();
    _getCurrentUserFieldsSubscriptions();
    switchValues = List.generate(10, (index) => false);
    loadSwitchStates();

    logger.i(switchValues);
  }

  Future<void> loadSwitchStates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < teachersIDS.length; i++) {
        switchValues[i] = prefs.getBool(teachersIDS[i]) ?? false;
      }
    });
  }

  Future<void> saveSwitchState(int index, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(teachersIDS[index], value);
  }

  Future<void> _getCurrentUserFieldsSubscriptions() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<dynamic> teacherOfLearner = [];
    List<dynamic> subjectOfLearner = [];

    var userQuery =
    firestore.collection('learnersData').where('uid', isEqualTo: user.uid);
    userQuery.get().then((var querySnapshot) {
      if (querySnapshot.size > 0) {
        var documentSnapshot = querySnapshot.docs.first;
        // Map<String, dynamic>? data = documentSnapshot.data();

        //get the learners details
        teacherOfLearner = documentSnapshot.get('teachersID');
        subjectOfLearner = documentSnapshot.get('subjects');

        print(
            "Heres the teachers Is: $teacherOfLearner ${teacherOfLearner.length}");
        print(
            "Here are the subjects : $subjectOfLearner ${subjectOfLearner.length}");

        setState(() {
          teachersIDS = documentSnapshot.get('teachersID');
          subjectNames = documentSnapshot.get('subjects');
          // teachersIDS.add(teacherOfLearner);
          // subjectNames = subjectOfLearner;
        });
        print("Heres the teachers Is: $teachersIDS ${teachersIDS.length}");
        print("Here are the subjects : $subjectNames ${subjectNames.length}");

        //logger.i("$teachersIDS \n$subjectNames");
      } else {}
    }).catchError((error) => print('Failed to get document: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        elevation: .5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 15),
                height: MediaQuery.of(context).size.height,
                width: 80,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: teachersIDS.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            trailing: Switch(
                              value: switchValues[index],
                              onChanged: (value) {
                                if (value == false) {
                                  localNotificationService
                                      .subscribeToTopicDevice(teachersIDS[index]);
                                  Fluttertoast.showToast(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      msg: "Subscribed to ${teachersIDS[index]}");
                                  setState(() {
                                    switchValues[index] = value;
                                    saveSwitchState(index, value);
                                  });
                                } else {
                                  localNotificationService
                                      .subscribeToTopicDevice(teachersIDS[index]);
                                  Fluttertoast.showToast(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      msg: "Subscribed");
                                  setState(() {
                                    switchValues[index] = value;
                                    saveSwitchState(index, value);
                                  });
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.only(top: 15),
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: const ScrollPhysics(parent: null),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(subjectNames[index]),
                          );
                        },
                        itemCount: subjectNames.length,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
