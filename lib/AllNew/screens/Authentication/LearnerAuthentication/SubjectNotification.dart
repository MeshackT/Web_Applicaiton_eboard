import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yueway/AllNew/screens/Notifications/local_notifications.dart';
import 'package:yueway/AllNew/shared/constants.dart';

Logger logger = Logger(printer: PrettyPrinter(colors: true));
var user = FirebaseAuth.instance.currentUser!;

class SubjectNotifications extends StatefulWidget {
  List<dynamic> teachersIDS;
  List<dynamic> nameOfSubjects;

  SubjectNotifications(
      {Key? key, required this.teachersIDS, required this.nameOfSubjects})
      : super(key: key);

  @override
  State<SubjectNotifications> createState() => _SubjectNotificationsState();
}

class _SubjectNotificationsState extends State<SubjectNotifications> {
  List<dynamic> teachersIDS = []; // carries the ids of the teachers
  List<dynamic> subjectNames = []; // carries the names of the subjects
  List<bool> switchValues = []; //carries the index of switched == 10

  List<String> teachersID = ["a", "B"];
  List<bool> switchValuess = [];
  List<dynamic> subjectOfLearner = [];

  //access the class methods for subscription
  LocalNotificationService localNotificationService =
      LocalNotificationService();
  //used to save the state of widgets
  late SharedPreferences prefs;

  //called initially when the layout is laid
  @override
  void initState() {
    //_getCurrentUserFieldsSubscriptions(); //get the data for the lists above
    super.initState();
    //_initializePreferences(); //loads the previous state of a switch
    logger.e("List Length is: ${teachersIDS.length}");
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
        title: const Text("Notifications"),
        elevation: .5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 10, bottom: 10),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width / 5,
                    color: Theme.of(context).primaryColor.withOpacity(.4),
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        physics: const ScrollPhysics(parent: null),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: Switch(
                              inactiveThumbColor: Theme.of(context)
                                  .primaryColorLight
                                  .withOpacity(.6),
                              activeColor: Theme.of(context).primaryColorLight,
                              thumbIcon: MaterialStateProperty.resolveWith(
                                  (Set states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return const Icon(
                                    Icons.close,
                                    color: Colors.grey,
                                  );
                                }
                                return null; // All other states will use the default thumbIcon.
                              }),
                              value: switchValuess[index],
                              onChanged: (value) {
                                //toggleSwitch(index, value);
                                if (switchValuess[index] = value) {
                                  localNotificationService
                                      .subscribeToTopicDevice(
                                          widget.teachersIDS[index]);
                                  Fluttertoast.showToast(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      msg: "subscribed");
                                } else {
                                  localNotificationService
                                      .unSubscribeToTopicDevice(
                                          widget.teachersIDS[index]);
                                  Fluttertoast.showToast(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      msg: "unsubscribed");
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
                            //title: Text(widget.teachersIDS[index]),
                          );
                        },
                        itemCount: widget.teachersIDS.length,
                      ),
                    ),
                  ),
                ),
              ),
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
                        title: Text(
                          widget.nameOfSubjects[index],
                          style: textStyleText(context).copyWith(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                    itemCount: widget.nameOfSubjects.length,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
