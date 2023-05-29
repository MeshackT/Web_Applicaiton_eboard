import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yueway/AllNew/screens/Authentication/Authenticate.dart';
import 'package:yueway/AllNew/screens/Authentication/LearnerAuthentication/SubjectNotification.dart';
import 'package:yueway/AllNew/screens/Authentication/LearnerAuthentication/testingSwitches.dart';
import 'package:yueway/AllNew/screens/Notifications/local_notifications.dart';
import 'package:yueway/AllNew/screens/home/learnersHome.dart';
import '../../shared/constants.dart';
import '../home/home.dart';
import 'feedbackclass.dart';

Logger logger = Logger(printer: PrettyPrinter(colors: true));
var user = FirebaseAuth.instance.currentUser!;

class LearnerMore extends StatefulWidget {
  const LearnerMore({Key? key}) : super(key: key);

  @override
  State<LearnerMore> createState() => _LearnerMoreState();
}

class _LearnerMoreState extends State<LearnerMore> {
  bool isLoading = false;
  bool setOn = true;
  String appName = "";
  String appVersion = "";
  String appBuildUpNumber = "";
  String appPackage = "";

  String subscribedTopicAll = "AllToSee";
  LocalNotificationService localNotificationService =
      LocalNotificationService();

  List<dynamic> teacherIDS = [];
  List<dynamic> nameOfSubject = [];

  void _load() async {
    PackageInfo _packageInfo = await PackageInfo.fromPlatform();

    appName = _packageInfo.appName;
    appVersion = _packageInfo.version;
    appBuildUpNumber = _packageInfo.buildNumber;
    appPackage = _packageInfo.packageName;

    isLoading = false;
    setState(() {});
  }

  Future<void> _loadSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      setOn = prefs.getBool('my_switch_state') ?? false;
    });
  }

  //switch state
  Future<void> _saveSwitchState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('my_switch_state', value);
  }

  @override
  void initState() {
    super.initState();
    _load();
    _loadSwitchState();
    _getCurrentUserFieldsSubscriptions();
  }

  //query the database for the required lists (IDS and subjects)
  Future<void> _getCurrentUserFieldsSubscriptions() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    var userQuery =
        firestore.collection('learnersData').where('uid', isEqualTo: user.uid);
    try {
      var querySnapshot = await userQuery.get();
      if (querySnapshot.size > 0) {
        var documentSnapshot = querySnapshot.docs.first;

        setState(() {
          teacherIDS = List.from((documentSnapshot.get('teachersID')));
          nameOfSubject = List.from(documentSnapshot.get('subjects'));
        });
        logger.i(teacherIDS.length);
      }
    } catch (error) {
      print('Failed to get document: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OutlinedButton(
                    style: buttonRound,
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const LearnerHome()));
                    },
                    child: Text(
                      "Back",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  spaceVertical(),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).primaryColorLight.withOpacity(.4),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "About ",
                              style: textStyleText(context).copyWith(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                letterSpacing: 1,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              "An electronic board for both learners and teacher."
                              " Send your notification as a teacher to learners."
                              " Get your notification feeds directly from the application.",
                              style: textStyleText(context).copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                letterSpacing: 1,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.6),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SubjectNotifications(
                                            teachersIDS: teacherIDS,
                                            nameOfSubjects: nameOfSubject,
                                          )));
                              // showSheetForNotifications();
                              print("hi");
                            },
                            child: Card(
                              child: Container(
                                height: 30,
                                //color: Colors.red,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.5),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Change Subject Notifications",
                                    textAlign: TextAlign.start,
                                    style: textStyleText(context).copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .primaryColorLight),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Switch(
                              value: setOn,
                              inactiveThumbColor: Theme.of(context)
                                  .primaryColorLight
                                  .withOpacity(.6),
                              activeColor: Theme.of(context).primaryColor,
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
                              onChanged: (val) async {
                                // Update the value of setOn
                                try {
                                  // Update the value of setOn
                                  if (setOn == false) {
                                    setState(() {
                                      setOn = val;
                                    });
                                    localNotificationService
                                        .subscribeToTopicDevice(
                                            subscribedTopicAll);
                                    logger.i(val);
                                    Fluttertoast.showToast(msg: "subscribed");
                                  } else {
                                    setState(() {
                                      setOn = val;
                                    });
                                    localNotificationService
                                        .unSubscribeToTopicDevice(
                                            subscribedTopicAll);
                                    logger.i(val);
                                    Fluttertoast.showToast(msg: "unSubscribed");
                                  }
                                  _saveSwitchState(val);
                                } on Exception catch (e) {
                                  snack(e.toString(), context);
                                  logger.i(e);
                                }
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Change Global Notifications",
                              style: textStyleText(context).copyWith(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: null,
                              //     () {
                              //   Navigator.of(context).pushReplacement(
                              //       MaterialPageRoute(
                              //           builder: (context) =>
                              //            TeacherListPage(teachersIDS: teacherIDS,)));
                              // },
                              child: Text(""),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  spaceVertical(),
                  Container(
                    height: 120,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).primaryColorLight.withOpacity(.4),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Share with friends",
                          style: textStyleText(context).copyWith(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              letterSpacing: 1),
                        ),
                        spaceVertical(),
                        InkWell(
                          onTap: () {
                            showSheetToShare(context);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            width: MediaQuery.of(context).size.width,
                            height: 30,
                            child: Text(
                              "Share with friends",
                              textAlign: TextAlign.start,
                              style: textStyleText(context).copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                letterSpacing: 1,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.6),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () {
                            showSheetToSendUsFeedback(context);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            width: MediaQuery.of(context).size.width,
                            height: 30,
                            child: Text(
                              "Send us Feedback",
                              textAlign: TextAlign.start,
                              style: textStyleText(context).copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                letterSpacing: 1,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.6),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  spaceVertical(),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const Authenticate(),
                          ),
                        );
                      } catch (e) {
                        snack("Failed to sign out", context);
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).primaryColorLight.withOpacity(.4),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Text(
                          "Sign Out",
                          style: textStyleText(context).copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            letterSpacing: 1,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  spaceVertical(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: isLoading
                        ? SpinKitChasingDots(
                            color: Theme.of(context).primaryColor,
                          )
                        : Text(
                            "App Name: $appName\nApp Version: $appVersion\nApp BuildNumber: $appBuildUpNumber\n$appPackage",
                            style: textStyleText(context).copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              letterSpacing: 1,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.6),
                            ),
                            textAlign: TextAlign.start,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //TODO Show bottom Sheet To add Subject to the learner
  showSheetToSendUsFeedback(BuildContext context) {
    //controllers
    TextEditingController nameOfSender = TextEditingController();
    TextEditingController emailOfSender = TextEditingController();
    TextEditingController messageOfSender = TextEditingController();
    TextEditingController subjectOfSender = TextEditingController();

    showModalBottomSheet(
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      enableDrag: true,
      elevation: 1,
      context: context,
      builder: (context) {
        return SafeArea(
          child: Container(
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
            child: Column(children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: buttonRound,
                      child: Text(
                        "Discard",
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
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 3),
                        child: Column(children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                            ),
                            child: Container(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.7),
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: Center(
                                child: Text(
                                  "What's your feedback?",
                                  style: textStyleText(context).copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Apple SD Gothic Neo',
                                      color:
                                          Theme.of(context).primaryColorLight),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: nameOfSender,
                            maxLines: 1,
                            decoration: textInputDecoration.copyWith(
                              hintText: "Your name here",
                              hintStyle: textStyleText(context).copyWith(
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.7),
                              ),
                            ),
                            style: textStyleText(context),
                            textAlign: TextAlign.center,
                            autocorrect: true,
                            textAlignVertical: TextAlignVertical.center,
                            onSaved: (value) {
                              //Do something with the user input.
                              nameOfSender.text = value!;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: emailOfSender,
                            maxLines: 1,
                            decoration: textInputDecoration.copyWith(
                              hintText: "Your email here",
                              hintStyle: textStyleText(context).copyWith(
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.7),
                              ),
                            ),
                            style: textStyleText(context),
                            textAlign: TextAlign.center,
                            autocorrect: true,
                            textAlignVertical: TextAlignVertical.center,
                            onSaved: (value) {
                              //Do something with the user input.
                              emailOfSender.text = value!;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: subjectOfSender,
                            maxLines: 1,
                            decoration: textInputDecoration.copyWith(
                              hintText: "Your subject here",
                              hintStyle: textStyleText(context).copyWith(
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.7),
                              ),
                            ),
                            style: textStyleText(context),
                            textAlign: TextAlign.center,
                            autocorrect: true,
                            maxLength: 45,
                            textAlignVertical: TextAlignVertical.center,
                            onSaved: (value) {
                              //Do something with the user input.
                              subjectOfSender.text = value!;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: messageOfSender,
                            maxLines: 4,
                            decoration: textInputDecoration.copyWith(
                              hintText: "Your message here",
                              hintStyle: textStyleText(context).copyWith(
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.7),
                              ),
                            ),
                            style: textStyleText(context),
                            textAlign: TextAlign.center,
                            autocorrect: true,
                            textAlignVertical: TextAlignVertical.center,
                            onSaved: (value) {
                              //Do something with the user input.
                              messageOfSender.text = value!;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton(
                                  onPressed: () async {
                                    if (nameOfSender.text.isEmpty ||
                                        emailOfSender.text.isEmpty ||
                                        subjectOfSender.text.isEmpty ||
                                        messageOfSender.text.isEmpty) {
                                      snack("Insert your details and message",
                                          context);
                                    } else {
                                      SendEmail.sendEmail(
                                        name: nameOfSender.text,
                                        message: messageOfSender.text,
                                        subject: subjectOfSender.text,
                                        email: emailOfSender.text,
                                      );
                                      Fluttertoast.showToast(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          msg:
                                              "Thank you for your feedback, your email submitted.");
                                      Navigator.of(context).pop();
                                    }
                                    nameOfSender.clear();
                                    messageOfSender.clear();
                                    subjectOfSender.clear();
                                    emailOfSender.clear();
                                  },
                                  style: buttonRound,
                                  child: Text(
                                    "Send",
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
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }

//TODO Show bottom Sheet To add Subject to the learner
  showSheetToShare(BuildContext context) {
    showModalBottomSheet(
      barrierColor: Theme.of(context).primaryColor.withOpacity(.1),
      isScrollControlled: true,
      enableDrag: true,
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      context: context,
      builder: (context) {
        return Wrap(
          alignment: WrapAlignment.center,
          children: [
            SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  //screen background color
                  gradient: LinearGradient(
                      colors: [Color(0x0fffffff), Color(0xE7791971)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Share these applications with your friends",
                          style: textStyleText(context).copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 70),
                          child: Divider(
                            height: 7,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            FlutterShare.share(
                                title: "E-Board application",
                                chooserTitle: "E-Board application",
                                text: "Download E-board on appStore",
                                linkUrl:
                                    "https://play.google.com/store/apps/details?id=com.eq.yueway");
                          },
                          child: Text(
                            "E-Board",
                            textAlign: TextAlign.start,
                            style: textStyleText(context).copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            FlutterShare.share(
                                title: "Yueway Go application",
                                chooserTitle: "Yueway Go application",
                                text: "Download Yueway Go on appStores",
                                linkUrl:
                                    "https://play.google.com/store/apps/details?id=com.yueway.yueway_go");
                          },
                          child: Text(
                            "Yueway Go",
                            textAlign: TextAlign.start,
                            style: textStyleText(context).copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            FlutterShare.share(
                                title: "E-Board application",
                                chooserTitle: "Yueway application",
                                text: "Download Yueway on appStores",
                                linkUrl:
                                    "https://play.google.com/store/apps/details?id=com.eq.yueway");
                          },
                          child: Text(
                            "Yueway Security",
                            style: textStyleText(context).copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            FlutterShare.share(
                                title: "E-Board application",
                                chooserTitle:
                                    "Revival Life Ministry application",
                                text:
                                    "Download Revival Life Ministry application on appStores",
                                linkUrl:
                                    "https://play.google.com/store/apps/det"
                                    "ails?id=com.yueway.revival_life_ministry");
                          },
                          child: Text(
                            "Revival Life Ministry",
                            style: textStyleText(context).copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  spaceVertical() {
    return const SizedBox(
      height: 10,
    );
  }

  Future deleteUser(BuildContext context) async {
    try {
      final db = FirebaseFirestore.instance;
      final userCollection = db.collection('userData');
      final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

      logger.i("current user: $currentUserUid");

      userCollection.get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((DocumentSnapshot doc) {
          if (doc.get("uid") == currentUserUid) {
            doc.reference.delete().then((value) {
              logger.i('Document with ID ${doc.id} deleted successfully');
              snack("I deleted my account.", context);
            }).catchError((error) {
              logger.i('Error deleting document: $error');
            });
          } else {
            snack("No user Found!", context);
          }
        });
      }).catchError((error) {
        logger.i('Error getting documents: $error');
        snack(error.toString(), context);
      });
      //FirebaseAuth.instance.currentUser!.delete();
    } catch (e) {
      snack(e.toString(), context);
      return null;
    }
  }

//Navigate to the previous page
  Future navigate(BuildContext context) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Home(),
      ),
    );
  }
}
