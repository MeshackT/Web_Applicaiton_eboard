import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yueway/AllNew/screens/Authentication/guestView.dart';
import 'package:yueway/main.dart';
import '../../model/ConnectionChecker.dart';
import '../../shared/constants.dart';
import '../home/home.dart';
import 'LearnerAuthentication/Authenticate.dart';
import 'forgotPage.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  const SignIn({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  //we access signing previlages using this class
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool passwordVisible = true;

  //textField state
  String email = '';
  String password = '';
  String error = '';
  String codeUnit = '';
  bool loading = false;
  String role = "teacher";
  String code = '';
  String codePassword = "WMPSST";

  @override
  void initState() {
    super.initState();
    ConnectionChecker.checkTimer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder(builder: (context, constraints) {
    //   if (constraints.maxWidth < Utils.mobileWidth) {
    //     return mobileBody;
    //   } else {
    //     return desktopBody;
    //   }
    // });
    return Scaffold(
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
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 0),
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
                            "Facilitator\nSign In",
                            textAlign: TextAlign.center,
                            style: textStyleText(context).copyWith(
                                color: Theme.of(context).primaryColorLight,
                                fontSize: 28,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                  height: 30,
                                  child: Text(
                                    "Are you a learner?",
                                    style: textStyleText(context).copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w700),
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LearnerAuthenticate(),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    height: 30,
                                    child: Text(
                                      "Click here!",
                                      style: textStyleText(context).copyWith(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Facilitator',
                                style: textStyleText(context)
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
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
                                  'Code',
                                  style: textStyleText(context),
                                ),
                                hintText: "Insert Code"),
                            obscureText: passwordVisible,
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
                            height: 10,
                          ),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              hintText: "Email",
                              hintStyle: textStyleText(context),
                            ),
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
                              hintText: "Password",
                              hintStyle: textStyleText(context),
                            ),
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 30,
                                child: Text(
                                  "Forgot password?",
                                  style: textStyleText(context).copyWith(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Forgot(),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    height: 30,
                                    child: Text(
                                      "Reset",
                                      style: textStyleText(context).copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 20,
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
                                  final navigatorContext =
                                      Navigator.of(context);

                                  //check if the form is validated
                                  if (_formKey.currentState!.validate()) {
                                    await signIn();
                                  } else {
                                    snack("Failed to Sign In", context);
                                  }
                                },
                                color: Theme.of(context).primaryColor,
                                child: loading
                                    ? SpinKitChasingDots(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                      )
                                    : Text(
                                        "Sign In",
                                        style: textStyleText(context).copyWith(
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                            fontWeight: FontWeight.w700),
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
                                  "Sign Up",
                                  style: textStyleText(context).copyWith(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      fontWeight: FontWeight.w700),
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
                    ),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50),
                    ),
                    child: SizedBox(
                      width: 150,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const GuestView(),
                            ),
                          );
                        },
                        child: Text(
                          "I am a guest",
                          style: textStyleText(context).copyWith(
                            color: Theme.of(context).primaryColorLight,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Works perfect
  Future<void> signIn() async {
    setState(() {
      loading = true;
    });

    final navContext = Navigator.of(context);
    try {
      // Check if user exists
      bool userExists = false;
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password.trim(),
      );
      userExists = userCredential.user != null;

      // Navigate to the home screen if user exists
      if (userExists) {
        navContext.pushReplacement(
            MaterialPageRoute(builder: (context) => const Home()));
      } else if (!userExists) {
        snack("Email doesn't exist.", context);
      } else {
        Fluttertoast.showToast(msg: 'Email account not registered');
        snack("Email doesn't exist.", context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code != 'user-not-found') {
        snack("Email not registered", context);
        return;
      } else if (e.code != 'wrong-password') {
        snack("Wrong password", context);
      }
    } catch (error) {
      // Handle other types of errors
      switch (error) {
        case 'ERROR_INVALID_EMAIL':
        case 'ERROR_WRONG_PASSWORD':
        case 'ERROR_USER_DISABLED':
        case 'ERROR_TOO_MANY_REQUESTS':
        case 'ERROR_OPERATION_NOT_ALLOWED':
          snack(error.toString(), context);
          break;
        default:
          snack('An unknown error occurred', context);
          break;
      }
    }

    setState(() {
      loading = false;
    });

    // Clear the login scren stack from the navigator
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
