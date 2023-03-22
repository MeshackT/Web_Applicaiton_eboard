import 'package:flutter/material.dart';

import 'register.dart';
import 'sign_in.dart';

class LearnerAuthenticate extends StatefulWidget {
  const LearnerAuthenticate({Key? key}) : super(key: key);

  @override
  State<LearnerAuthenticate> createState() => _LearnerAuthenticateState();
}

class _LearnerAuthenticateState extends State<LearnerAuthenticate> {

  bool showSignIn = true;

  void toggleView(){
    setState(() {
      //get the reverse of showSign In
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn == true){
      return LearnerSignIn(toggleView: toggleView);
    }else{
      return LearnerRegister(toggleView: toggleView);
    }
  }
}
