import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../shared/constants.dart';
import '../home/home.dart';
import 'feedbackclass.dart';

class More extends StatefulWidget {
  const More({Key? key}) : super(key: key);

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  bool isLoading = false;
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _packageInfo;
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
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
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OutlinedButton(
                    style: buttonRound,
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const Home()));
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
                      color: Theme.of(context).primaryColorLight.withOpacity(.4),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
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
                        Padding(
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
                              color:
                                  Theme.of(context).primaryColor.withOpacity(.6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  spaceVertical(),
                  Container(
                    height: 120,
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight.withOpacity(.4),
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
                      } catch (e) {
                        snack("Failed to sign out", context);
                      }
                      setState(() {
                        isLoading = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).primaryColorLight.withOpacity(.4),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                    child: Text(
                      "App Name: ${_packageInfo.appName}\nApp Version: ${_packageInfo.version}\nApp Version: ${_packageInfo.buildNumber}\nApp Version: ${_packageInfo.buildSignature}",
                      style: textStyleText(context).copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        letterSpacing: 1,
                        color: Theme.of(context).primaryColor.withOpacity(.6),
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
                        padding:
                        const EdgeInsets.symmetric(horizontal: 25.0, vertical: 3),
                        child: Column(children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                            ),
                            child: Container(
                              color: Theme.of(context).primaryColor.withOpacity(.7),
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: Center(
                                child: Text(
                                  "What's your feedback?",
                                  style: textStyleText(context).copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Apple SD Gothic Neo',
                                      color: Theme.of(context).primaryColorLight),
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
                                color: Theme.of(context).primaryColor.withOpacity(.7),
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
                                color: Theme.of(context).primaryColor.withOpacity(.7),
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
                                color: Theme.of(context).primaryColor.withOpacity(.7),
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
                                color: Theme.of(context).primaryColor.withOpacity(.7),
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
                                      snack("Insert your details and message", context);
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
}

//TODO Show bottom Sheet To add Subject to the learner
showSheetToShare(BuildContext context) {
  bool isLoading = false;
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
                            text: "Download Yueway on appStores",
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
                            title: "E-Board application",
                            chooserTitle: "E-Board application",
                            text: "Download Yueway on appStores",
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
                            chooserTitle: "E-Board application",
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
                            chooserTitle: "E-Board application",
                            text: "Download Yueway on appStores",
                            linkUrl: "https://play.google.com/store/apps/det"
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
