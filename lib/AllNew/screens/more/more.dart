import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../shared/constants.dart';
import '../home/home.dart';
import 'DektopLayouts/DesktopMore.dart';
import 'feedbackclass.dart';

Logger logger = Logger(printer: PrettyPrinter(colors: true));
var user = FirebaseAuth.instance.currentUser;

class More extends StatefulWidget {
  const More({Key? key}) : super(key: key);

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  bool isLoading = false;
  bool loader = false;
  var widthSize = 2.2;
  var widthSize_1 = 1;

  String appName = "";
  String appVersion = "";
  String appBuildUpNumber = "";
  String appPackage = "";

  void _load() async {
    PackageInfo _packageInfo = await PackageInfo.fromPlatform();

    appName = _packageInfo.appName;
    appVersion = _packageInfo.version;
    appBuildUpNumber = _packageInfo.buildNumber;
    appPackage = _packageInfo.packageName;

    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return const DesktopMore();
  }

  //TODO send FeedBack
  desktopShowSheetToSendUsFeedback(BuildContext context) {
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
            // decoration: const BoxDecoration(
            //   //screen background color
            //   gradient: LinearGradient(
            //       colors: [Color(0x0fffffff), Color(0xE7791971)],
            //       begin: Alignment.topLeft,
            //       end: Alignment.bottomRight),
            // ),
            color: Theme.of(context).primaryColorLight,

            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
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
                                        color: Theme.of(context)
                                            .primaryColorLight),
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
                                      setState(() {
                                        loader = true;
                                      });
                                      Utils.showDownloading(
                                          context,
                                          "Sending your email.",
                                          "Please wait a few seconds...");

                                      //validate the inputs
                                      try {
                                        if (nameOfSender.text.isEmpty ||
                                            emailOfSender.text.isEmpty ||
                                            subjectOfSender.text.isEmpty ||
                                            messageOfSender.text.isEmpty) {
                                          snack(
                                              "Insert your details and message",
                                              context);
                                        } else {
                                          //send the message through an API from email JS email
                                          SendEmail.sendEmail(
                                            name: nameOfSender.text,
                                            message: messageOfSender.text,
                                            subject: subjectOfSender.text,
                                            email: emailOfSender.text
                                                .trim()
                                                .toLowerCase(),
                                          );
                                        }
                                        // turn off the loader
                                        setState(() {
                                          loader = false;
                                        });
                                        //close the sheet
                                        Navigator.of(context).pop();
                                        //communicate the process after
                                        Fluttertoast.showToast(
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            msg:
                                                "Thank you for your feedback, your email submitted.");

                                        //clear the data in those textfields
                                        nameOfSender.clear();
                                        messageOfSender.clear();
                                        subjectOfSender.clear();
                                        emailOfSender.clear();
                                      } on Exception catch (e) {
                                        // TODO
                                        Fluttertoast.showToast(
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            msg:
                                                "failed to send the feedback, please try again later");
                                        logger.i(e);
                                      }
                                    },
                                    style: buttonRound,
                                    child: Text(
                                      "Send",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Theme.of(context).primaryColorDark,
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
          ),
        );
      },
    );
  }

  //TODO Desktop showFeedBack
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
                                    setState(() {
                                      loader = true;
                                    });
                                    Utils.showDownloading(
                                        context,
                                        "Sending your email.",
                                        "Please wait a few seconds...");

                                    //validate the inputs
                                    try {
                                      if (nameOfSender.text.isEmpty ||
                                          emailOfSender.text.isEmpty ||
                                          subjectOfSender.text.isEmpty ||
                                          messageOfSender.text.isEmpty) {
                                        snack("Insert your details and message",
                                            context);
                                      } else {
                                        //send the message through an API from email JS email
                                        SendEmail.sendEmail(
                                          name: nameOfSender.text,
                                          message: messageOfSender.text,
                                          subject: subjectOfSender.text,
                                          email: emailOfSender.text
                                              .trim()
                                              .toLowerCase(),
                                        );
                                      }
                                      // turn off the loader
                                      setState(() {
                                        loader = false;
                                      });
                                      //close the sheet
                                      Navigator.of(context).pop();
                                      //communicate the process after
                                      Fluttertoast.showToast(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          msg:
                                              "Thank you for your feedback, your email submitted.");

                                      //clear the data in those textfields
                                      nameOfSender.clear();
                                      messageOfSender.clear();
                                      subjectOfSender.clear();
                                      emailOfSender.clear();
                                    } on Exception catch (e) {
                                      // TODO
                                      Fluttertoast.showToast(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          msg:
                                              "failed to send the feedback, please try again later");
                                      logger.i(e);
                                    }
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

  //TODO Enquiry  details hr/none teacher
  showSheetForAddingEnquiries(BuildContext context) {
    //controllers
    TextEditingController emailForEnquiry = TextEditingController();
    TextEditingController primaryContact = TextEditingController();
    TextEditingController secondaryContact = TextEditingController();

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
                                  style: textStyleText(context).copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Apple SD Gothic Neo',
                                      color:
                                          Theme.of(context).primaryColorLight),
                                  "Enquiry details.",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: emailForEnquiry,
                            maxLines: 1,
                            decoration: textInputDecoration.copyWith(
                              hintText: "Enquiry email here...",
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
                              emailForEnquiry.text = value!;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: primaryContact,
                            maxLines: 1,
                            decoration: textInputDecoration.copyWith(
                              hintText: "Primary contact",
                              hintStyle: textStyleText(context).copyWith(
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.7),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: textStyleText(context),
                            textAlign: TextAlign.center,
                            autocorrect: true,
                            textAlignVertical: TextAlignVertical.center,
                            onSaved: (value) {
                              //Do something with the user input.
                              primaryContact.text = value!;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: secondaryContact,
                            decoration: textInputDecoration.copyWith(
                              hintText: "Secondary contact",
                              hintStyle: textStyleText(context).copyWith(
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.7),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: textStyleText(context),
                            textAlign: TextAlign.center,
                            autocorrect: true,
                            textAlignVertical: TextAlignVertical.center,
                            onSaved: (value) {
                              //Do something with the user input.
                              secondaryContact.text = value!;
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
                                    final navContext = Navigator.of(context);
                                    final themeContext = Theme.of(context);
                                    bool loader = false;

                                    final CollectionReference
                                        detailsForEnquiry = FirebaseFirestore
                                            .instance
                                            .collection('enquiryDetails');
                                    final DocumentReference identityDocument =
                                        detailsForEnquiry.doc(user!.uid);

                                    if (emailForEnquiry.text.isEmpty ||
                                        primaryContact.text.isEmpty) {
                                      snack("Insert your details and message",
                                          context);
                                    } else {
                                      setState(() {
                                        loader = true;
                                      });
                                      Utils.showDownloading(
                                          context,
                                          "Updating enquiry details",
                                          "Please wait a few seconds...");

                                      ///TODO add these to the database
                                      await identityDocument.set({
                                        "emailForEnquiry": emailForEnquiry.text
                                            .trim()
                                            .toLowerCase(),
                                        "primaryContact":
                                            primaryContact.text.trim(),
                                        "secondaryContact":
                                            secondaryContact.text.trim() ?? "",
                                        "userUID": user!.uid,
                                      }, SetOptions(merge: true));

                                      setState(() {
                                        loader = false;
                                      });
                                      Fluttertoast.showToast(
                                          backgroundColor:
                                              themeContext.primaryColor,
                                          msg: "Details updated");
                                    }
                                    primaryContact.clear();
                                    secondaryContact.clear();
                                    emailForEnquiry.clear();
                                    navContext.pop();
                                  },
                                  style: buttonRound,
                                  child: Text(
                                    "Add",
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
                              chooserTitle: "Revival Life Ministry application",
                              text:
                                  "Download Revival Life Ministry application on appStores",
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
          ),
        ],
      );
    },
  );
}
/////end of enquire details

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
