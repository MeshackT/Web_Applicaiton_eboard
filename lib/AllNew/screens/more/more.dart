import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:levy/AllNew/screens/home/home.dart';

class More extends StatelessWidget {
  const More({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .5,
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                navigate(context);
              },
              icon: const Icon(Icons.arrow_back),),          ],
        ),
        backgroundColor: Colors.purple,
      ),

    );
  }
}


//Navigate to the previous page
Future navigate(BuildContext context){
  return Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context)=> const Home(),),);
}