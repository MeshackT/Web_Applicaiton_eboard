import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:levy/AllNew/screens/gradeList/grade12.dart';
import 'package:levy/AllNew/shared/constants.dart';

import '../../main.dart';

//A Model to grab and store data
class User {
  final String email;
  final String uid;
  final String password;
  final String name;
  final String documentID;
  final List<String> subjects;

  User(
    this.email,
    this.uid,
    this.password,
    this.name,
    this.documentID,
    this.subjects,
  );

  final userData = FirebaseFirestore.instance.collection('userData').doc();

  Future<void> addUser() {
    //get document ID
    final documentID = userData.id;

    // Call the user's CollectionReference to add a new user
    return userData
        .set({
          'documentID': documentID,
          'email': email, // John Doe
          'uid': uid, // Stokes and Sons
          'password': password, //
          'name': name,
          'subjects': subjects, //
        })
        .then((value) => print("User Data"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
//=====================================================================

class Register extends StatefulWidget {
  final Function toggleView;

  const Register({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  //we access signing privileges using this class
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //textField state
  String email = '';
  String password = '';
  String confirmPassword = '';
  String uid = '';
  String name = '';
  String documentID = '';
  String subject1 = '';
  String subject2 = '';
  List<String> subjects = [];
  String role = "teacher";
  String code = '';
  String codePassword = "WMPSST";

  String error = '';
  bool loading = false;
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(1),
          content: Text(
            'Tap back again to leave the application',
            style: TextStyle(color: Theme.of(context).primaryColorLight),
            textAlign: TextAlign.center,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        topRight: Radius.circular(280),
                        topLeft: Radius.circular(280),
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 5,
                        width: MediaQuery.of(context).size.width / 1.5,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(
                    child: Text(
                      "Facilitator\nSign up",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 150),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              enabled: false,
                              decoration: textInputDecoration.copyWith(
                                  label: Text(
                                    'Teacher',
                                    style: textStyleText(context),
                                  ),
                                  hintText: "Teacher"),
                              onChanged: (val) {
                                setState(() {
                                  email = role;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              obscureText: passwordVisible,
                              decoration: textInputDecoration.copyWith(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                    icon: passwordVisible
                                        ? Icon(
                                            Icons.visibility,
                                            color: IconTheme.of(context).color,
                                          )
                                        : Icon(
                                            Icons.lock,
                                            color: IconTheme.of(context).color,
                                          ),
                                  ),
                                  label: Text(
                                    'Code',
                                    style: textStyleText(context),
                                  ),
                                  hintText: "Insert Code"),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "enter a code";
                                } else if (codePassword != code) {
                                  return "Incorrect code";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  code = val;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  label: Text(
                                    'Email',
                                    style: textStyleText(context),
                                  ),
                                  hintText: "examle@gmail.com"),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "enter an email";
                                } else if (!val.contains("@")) {
                                  return "enter a correct email";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                            ),
                            //Name
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  label: Text(
                                    'Name',
                                    style: textStyleText(context),
                                  ),
                                  hintText: "Enter your names"),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "enter your names";
                                } else if (val.length < 3) {
                                  return "enter your correct name";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  name = val;
                                });
                              },
                            ),
                            //subject1
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  label: Text(
                                    'Subject',
                                    style: textStyleText(context),
                                  ),
                                  hintText: "Subject"),
                              obscureText: false,
                              validator: (val) {
                                if (val!.length < 3) {
                                  return "Invalid subject";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  subject1 = val;
                                });
                              },
                            ),
                            //subject1
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  label: Text(
                                    'Additional Subject (Optional)',
                                    style: textStyleText(context),
                                  ),
                                  hintText: "Subject"),
                              obscureText: false,
                              onChanged: (val) {
                                setState(() {
                                  subject2 = val;
                                });
                              },
                            ),

                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                    icon: passwordVisible
                                        ? Icon(
                                            Icons.visibility,
                                            color: IconTheme.of(context).color,
                                          )
                                        : Icon(
                                            Icons.lock,
                                            color: IconTheme.of(context).color,
                                          ),
                                  ),
                                  label: Text(
                                    'Password',
                                    style: textStyleText(context),
                                  ),
                                  hintText: "Enter your password"),
                              obscureText: passwordVisible,
                              validator: (val) {
                                if (val!.length < 6) {
                                  return "enter a password greater than 5";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                    icon: passwordVisible
                                        ? Icon(
                                            Icons.visibility,
                                            color: Colors.purple.shade500,
                                          )
                                        : Icon(
                                            Icons.lock,
                                            color: Colors.purple.shade500,
                                          ),
                                  ),
                                  label: Text(
                                    'Confirm Password',
                                    style: textStyleText(context),
                                  ),
                                  hintText: "confirm your password"),
                              obscureText: true,
                              validator: (val) {
                                if (!confirmPassword
                                    .trim()
                                    .contains(password.trim())) {
                                  return "Passwords don't match";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  confirmPassword = val;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),

                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(70),
                                topLeft: Radius.circular(70),
                              ),
                              child: SizedBox(
                                width: 120,
                                child: MaterialButton(
                                  height: 60,
                                  onPressed: () async {
                                    //check if the form is validated
                                    if (_formKey.currentState!.validate()) {
                                      //set this state when I press the button
                                      signUp();
                                    } else {
                                      setState(() {
                                        snack("Failed to register", context);
                                      });
                                    }
                                  },
                                  color: Theme.of(context).primaryColor,
                                  child: loading
                                      ? SpinKitChasingDots(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        )
                                      : Text(
                                          "Sign Up",
                                          style: textStyleText(context)
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColorLight),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(70),
                                bottomRight: Radius.circular(70),
                              ),
                              child: SizedBox(
                                width: 120,
                                child: MaterialButton(
                                  height: 60,
                                  onPressed: () {
                                    widget.toggleView();
                                  },
                                  color: Theme.of(context).primaryColor,
                                  child: Text(
                                    "Sign In",
                                    style: textStyleText(context).copyWith(
                                        color: Theme.of(context)
                                            .primaryColorLight),
                                  ),
                                ),
                              ),
                            ),

                            Text(
                              error,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    try {
      setState(() {
        loading = true;
      });

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.toLowerCase().trim(), password: password);

      final FirebaseAuth auth = FirebaseAuth.instance;
      //get Current User
      final userCurrent = auth.currentUser!.uid;
      //store user in a string/
      uid = userCurrent.toString();

      subjects.add(subject1);
      subjects.add(subject2);

      //insert data using a class
      User _user = User(email.trim().toLowerCase(), uid, password.trim(),
          name.trim(), documentID, subjects);
      //this should add the registered user to the userData collection with UID
      _user.addUser();
      logger.i(_user.addUser());

      //set this state after I press the button
      setState(() {
        loading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      if (e.code == 'email-already-in-use') {
        setState(() {
          loading = false;
          snack("Email already exists", context);
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
        snack(e.toString(), context);
      });
    }
    //Navigator.current
    navigatorKey.currentState!.popUntil((route) {
      return route.isFirst;
    });
  }
}
