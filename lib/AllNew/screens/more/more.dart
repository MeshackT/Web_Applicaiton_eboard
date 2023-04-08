import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:levy/AllNew/screens/Authentication/Authenticate.dart';
import 'package:levy/AllNew/screens/home/home.dart';

import '../../shared/constants.dart';

class More extends StatelessWidget {
  const More({Key? key}) : super(key: key);

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutlinedButton(
                  style: buttonRound,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder:
                        (context) =>const Home()));
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "About ",
                          style: textStyleText(context).copyWith(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      spaceVertical(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          textAlign: TextAlign.start,
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
                        onTap: () {},
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
                        onTap: () {},
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
                  onTap: () {
                    deleteUser(context)
                        .then((value) => logger.i("user Deleted"))
                        .whenComplete(
                          () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const Authenticate(),
                            ),
                          ),
                        );
                    // FirebaseAuth.instance.currentUser!.delete();
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
                        "Delete my account permanently?",
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
                  height: 50,
                  child: Text(
                    "App version 3.1.2.1",
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
    );
  }
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
