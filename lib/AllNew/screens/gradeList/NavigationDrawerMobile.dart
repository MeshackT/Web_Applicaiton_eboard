//NavigationDrawerForALlMobile

import 'package:Eboard/AllNew/screens/Authentication/DesktopAuthentication/DesktopTeacherProfile.dart';
import 'package:Eboard/AllNew/screens/home/DesktopHomeLayouts/DesktopHome.dart';
import 'package:Eboard/AllNew/screens/more/DektopLayouts/DesktopMore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../shared/constants.dart';
import '../Authentication/Authenticate.dart';
import 'grade10.dart';
import 'grade11.dart';
import 'grade12.dart';
import 'grade8.dart';
import 'grade9.dart';

class NavigationDrawerForAllMobile extends StatelessWidget {
  final String? nameOfTeacher;
  const NavigationDrawerForAllMobile({Key? key, required this.nameOfTeacher})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          boxShadow: const [
            BoxShadow(
              blurRadius: 3.0,
            )
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const DesktopTeachersProfile()));
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
                  Wrap(children: [
                    Text(
                      nameOfTeacher!,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColorLight),
                    ),
                  ]),
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
                  letterSpacing: 2,
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
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DesktopHomeLayout()));
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
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 1,
                    fontFamily: 'Poppins-Extrabold'),
              ),
              onTap: () {
                Navigator.of(context).push(
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
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Grade11()));
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
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
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
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
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
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 1),
              ),
              onTap: () {
                Navigator.of(context).push(
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
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 2,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DesktopMore()));
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
                    fontSize: 14,
                    fontWeight: FontWeight.w900),
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
