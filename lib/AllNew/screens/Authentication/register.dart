import 'package:Eboard/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../verifyEmailPage.dart';
import '../../shared/constants.dart';
import 'DesktopAuthentication/register_Desktop.dart';

//A Model to grab and store data
class User {
  final String email;
  final String uid;
  final String password;
  final String name;
  final String secondName;
  final String documentID;
  final List<String> subjects;

  User(
    this.email,
    this.uid,
    this.password,
    this.name,
    this.secondName,
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
          'secondName': secondName,
          'subjects': subjects, //
        })
        .then((value) => logger.i("User Data"))
        .catchError((error) => logger.i("Failed to add user: $error"));
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
  //final FirebaseAuth _auth = FirebaseAuth.instance;

  //textField state
  String email = '';
  String password = '';
  String confirmPassword = '';
  String uid = '';
  String name = '';
  String secondName = '';
  String documentID = '';

  // String subject1 = '';
  // String subject2 = '';
  List<String> subjects = [];
  String role = "teacher";
  String code = '';
  String codePassword = "WMPSST";

  String error = '';
  bool loading = false;
  bool passwordVisible = true;

  String? selectedOption;
  String? selectedOption1;

  List<String> listItem = [
    "arts and culture",
    "accounting",
    "afrikaans",
    "agriculture",
    "business studies",
    "cat",
    "consumer studies",
    "economic m s",
    "geography",
    "history",
    "isiZulu",
    "life sciences",
    "life orientation",
    "natural sciences",
    "physical sciences",
    "social sciences",
    "siphedi",
    "sisotho",
    "technology",
    "tourism",
    "english home language",
    "english second additional language",
    "mathematics",
    "mathematics literacy",
    "not applicable",
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < Utils.mobileWidth) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              margin: const EdgeInsets.only(top: 0.0),
              decoration: const BoxDecoration(
                //screen background color
                gradient: LinearGradient(
                    colors: [Color(0x0fffffff), Color(0xE7791971)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 0),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(0),
                                topRight: Radius.circular(280),
                                topLeft: Radius.circular(280),
                              ),
                              child: Container(
                                height: 180,
                                width: MediaQuery.of(context).size.width,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text(
                              "Facilitator\nSign up",
                              textAlign: TextAlign.center,
                              style: textStyleText(context).copyWith(
                                  color: Theme.of(context).primaryColorLight,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Facilitator',
                                style: textStyleText(context).copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w700),
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
                                              color:
                                                  IconTheme.of(context).color,
                                            )
                                          : Icon(
                                              Icons.lock,
                                              color:
                                                  IconTheme.of(context).color,
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
                                      'First Name',
                                      style: textStyleText(context),
                                    ),
                                    hintText: "Enter your first name"),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "enter your name";
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
                                      'Second Name',
                                      style: textStyleText(context),
                                    ),
                                    hintText: "Enter your second name"),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "enter your second name";
                                  } else if (val.length < 3) {
                                    return "enter your correct name";
                                  }
                                  return null;
                                },
                                onChanged: (val) {
                                  setState(() {
                                    secondName = val;
                                  });
                                },
                              ),
                              //subject
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColorLight
                                      .withOpacity(1),
                                  border: Border.all(
                                    color: Colors.purple,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  children: [
                                    DropdownButton(
                                      isExpanded: false,
                                      hint: Text(
                                        "Select a subject",
                                        style: textStyleText(context),
                                      ),
                                      //ValueChoose1
                                      value: selectedOption1,
                                      //listMathematics
                                      items: listItem
                                          .map<DropdownMenuItem<String>>(
                                            (e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(
                                                e,
                                                style: textStyleText(context),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectedOption1 = value;
                                          logger.i(selectedOption1);
                                        });
                                      },
                                    ),
                                    DropdownButton(
                                      isExpanded: false,
                                      hint: Text(
                                        "Optional Subject",
                                        style: textStyleText(context),
                                      ),
                                      //ValueChoose1
                                      value: selectedOption,
                                      //listMathematics
                                      items: listItem
                                          .map<DropdownMenuItem<String>>(
                                            (e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(
                                                e,
                                                style: textStyleText(context),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectedOption = value;
                                          logger.i(selectedOption);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
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
                                              color:
                                                  IconTheme.of(context).color,
                                            )
                                          : Icon(
                                              Icons.lock,
                                              color:
                                                  IconTheme.of(context).color,
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
                                obscureText: passwordVisible,
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
                              Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(1000),
                                        topLeft: Radius.circular(1000),
                                      ),
                                      child: SizedBox(
                                        width: 120,
                                        child: MaterialButton(
                                          height: 60,
                                          onPressed: () async {
                                            //check if the form is validated
                                            if (_formKey.currentState!
                                                .validate()) {
                                              //set this state when I press the button
                                              if (selectedOption1 == null ||
                                                  selectedOption == null ||
                                                  selectedOption1!.isEmpty ||
                                                  selectedOption!.isEmpty) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Select 'not applicable' if you are not teaching 2 subjects");
                                              } else {
                                                signUp();
                                              }
                                            } else {
                                              setState(() {
                                                snack("Failed to register",
                                                    context);
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
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorLight,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(1000),
                                        bottomRight: Radius.circular(1000),
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
                                            style: textStyleText(context)
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .primaryColorLight,
                                                    fontWeight:
                                                        FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
                  ],
                ),
              ),
            ),
          ),
        );
      } else {
        return const RegisterDesktop();
      }
    });
  }

  Future signUp() async {
    setState(() {
      loading = true;
    });
    final navContext = Navigator.of(context);
    try {
      // Check if email already exists
      final signInMethods = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(email.toLowerCase().trim());
      if (signInMethods.isNotEmpty) {
        snack("Email already exists", context);
        setState(() {
          loading = false;
        });
        return;
      }

      // Create new user account
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.toLowerCase().trim(), password: password.trim());

      final FirebaseAuth auth = FirebaseAuth.instance;
      //get Current User
      final userCurrent = auth.currentUser!.uid;
      //store user in a string/
      uid = userCurrent.toString();

      subjects.add(selectedOption1.toString());
      subjects.add(selectedOption.toString());

      //insert data using a class
      User _user = User(email.trim().toLowerCase(), uid, password.trim(),
          name.trim(), secondName.trim(), documentID, subjects);
      //this should add the registered user to the userData collection with UID
      await _user.addUser();
      navContext.pushReplacement(
          MaterialPageRoute(builder: (context) => const VerifyEmailPage()));
      //logger.i(_user.addUser());
    } on FirebaseAuthException catch (e) {
      snack(e.message!, context);
    } catch (e) {
      snack(e.toString(), context);
    }
    //Navigator.current
    navigatorKey.currentState!.popUntil((route) {
      return route.isFirst;
    });
    setState(() {
      loading = false;
    });
  }
}
