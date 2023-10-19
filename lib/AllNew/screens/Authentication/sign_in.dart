import 'package:Eboard/AllNew/screens/Authentication/DesktopAuthentication/sign_inDesktop.dart';
import 'package:Eboard/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../model/ConnectionChecker.dart';
import '../../shared/constants.dart';
import '../home/home.dart';

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
  bool showButton = false;

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
    return const DesktopSignIn();
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
