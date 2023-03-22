import 'package:flutter/material.dart';
import 'package:levy/AllNew/screens/Assignments/assignments.dart';
import 'package:levy/AllNew/screens/Exams/Exams.dart';
import 'package:levy/AllNew/screens/Tests/tests.dart';
import 'package:levy/AllNew/screens/gradeList/grade12.dart';

class Select extends StatefulWidget {
  const Select({Key? key}) : super(key: key);
  static const routeName = '/select';


  @override
  State<Select> createState() => _SelectState();
}

class _SelectState extends State<Select> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          leading: Row(
            children: [
                IconButton(
                  onPressed: (){
                    navigate(context);
                  },
                  icon: const Icon(Icons.arrow_back),),
            ],
          ),
          title: const Text("Term"),
          titleSpacing: 2,
          centerTitle: false,
          elevation: .5,
          backgroundColor: Colors.purple,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 5,
            tabs: [
              Tab(
                icon: Icon(Icons.school),
                text: "Term 1",
              ),
              Tab(
                icon: Icon(Icons.school),
                text: "Term 2",
              ),
              Tab(
                icon: Icon(Icons.school),
                text: "Term 3",
              ),
              Tab(
                icon: Icon(Icons.school),
                text: "Term 4",
              )
            ],

          ),
        ),
        backgroundColor: Colors.white,

        body: TabBarView(
          children: [
            //Tabs/Terms
            buildPage("Term 1"),
            buildPage("Term 2"),
            buildPage("Term 3"),
            buildPage("Term 4"),

          ],
        ),
      ),
    );
  }
  Widget buildPage(String title){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 30,),
        Text(title, style: const TextStyle(
          color: Colors.purple, fontSize: 18, fontWeight: FontWeight.w500
        ),),
        Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                clipRRect(
                      () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context)=>const TestsMarks())),
                  "Tests",
                  const BorderRadius.only(
                    topRight: Radius.circular(80),
                    topLeft:  Radius.circular(80),
                  ),
                ),

                const SizedBox(height: 20,),

                clipRRect(
                      () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context)=>const Assignments())),
                  "Assessment",
                  const BorderRadius.only(
                    topRight: Radius.circular(0),
                    topLeft:  Radius.circular(00),
                  ),
                ),
                const SizedBox(height: 20,),

                clipRRect(
                      () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context)=>const Exams())),
                  "Exams",
                  const BorderRadius.only(
                    bottomRight: Radius.circular(80),
                    bottomLeft:  Radius.circular(80),
                  ),
                ),
              ],
            ))
      ],

    );
  }
}


//Common Button

ClipRRect clipRRect(Function() onPress, String title, BorderRadius borderRadius ){
  return ClipRRect(
    borderRadius: borderRadius,
    child: Container(
      width: 180,
      color: Colors.purple.shade100,
      child: TextButton(
        onPressed: onPress,
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            fontSize: 18,
            letterSpacing: 2
          ),
        ),
      ),
    ),
  );
}

//Navigate to the previous page
Future navigate(BuildContext context){
  return Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context)=>const Grade12()));
}