import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LearnersHome extends StatefulWidget {
  const LearnersHome({Key? key}) : super(key: key);

  @override
  State<LearnersHome> createState() => _LearnersHomeState();
}

class _LearnersHomeState extends State<LearnersHome> {
  final TextEditingController _searchController = TextEditingController();

  //String searchN="";
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  CollectionReference allNoteCollection =
      FirebaseFirestore.instance.collection('learnersData');
  List<DocumentSnapshot> documents = [];

  String searchText = '';

  @override
  Widget build(BuildContext context) {
    // final Stream<QuerySnapshot> learnersData = FirebaseFirestore.instance
    //     .collection('learnersData').orderBy('grade', descending: true)
    //     .snapshots();
    // final Stream<QuerySnapshot> searchedLearnersData =FirebaseFirestore.instance
    //     .collection('learnersData')
    //     .orderBy('grade', descending: true)
    //     .where('name', isEqualTo: searchN)
    //     .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-Test"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  color: Colors.blueGrey,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.red,
                    child: StreamBuilder(
                      stream: allNoteCollection.snapshots(),
                      builder: (ctx, streamSnapshot) {
                        if (streamSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: SpinKitChasingDots(
                            color: Colors.purple,
                          ));
                        }
                        documents = streamSnapshot.data!.docs;
                        //todo Documents list added to filterTitle
                        if (searchText.isNotEmpty) {
                          documents = documents.where((element) {
                            return element
                                .get('name')
                                .toString()
                                .toLowerCase()
                                .contains(searchText.toLowerCase());
                          }).toList();
                        }

                        return ListView.separated(
                          //reverse: true,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: documents.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                          itemBuilder: (BuildContext context, int index) {
                            //print('Images ${documents[index]['Images'].length}');
                            //todo Pass this time
                            print('Name is : ${documents[index]['name']}');
                            String dateTime = documents[index]['grade'];
                            return ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              onTap: () {
                                String dateTime = documents[index]['name'];
                                print("Is $dateTime");
                              },
                              leading: CircleAvatar(
                                backgroundColor: Colors.purple,
                                child: Text(documents[index]['name'][0]),
                              ),
                              title: Text(documents[index]['name']),
                              subtitle:
                                  Text("Grade " + documents[index]['grade']),
                              trailing: IconButton(
                                onPressed: () {
                                  allNoteCollection
                                      .doc(documents[index].id)
                                      .delete();
                                },
                                icon: const Icon(Icons.delete,
                                    color: Colors.red, size: 22),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: searchedResult.length,
                //     itemBuilder: (BuildContext context, int index) {
                //       //DocumentSnapshot data = snapshot.data!.docs[index];
                //       return Column(
                //         children: [
                //
                //           const SizedBox(height: 5,),
                //           // const Text("A list of grade 12 Mathematics learners"),
                //           ListTile(
                //             leading: CircleAvatar(
                //               child: Text(
                //                   searchedResult[index]['name'][0]
                //               ),
                //             ),
                //             title: Text(
                //             searchedResult[index]['name'],
                //               style: const TextStyle(color: Colors.black),
                //             ),
                //             subtitle: Text("${"Grade " + searchedResult[index]['grade']
                //             }\nMathematics"),
                //             trailing:  SizedBox(
                //               width: 50,
                //               child: Row(
                //                 crossAxisAlignment: CrossAxisAlignment.center,
                //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                 children: [
                //                   IconButton(
                //                     color: Colors.blue,
                //                     onPressed:() async {
                //
                //
                //                     },
                //                     icon: const Icon(Icons.add, size: 30,),),
                //
                //                 ],
                //               ),
                //             ),
                //           ),
                //
                //         ],
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_key.currentState!.validate()) {
            _key.currentState!.save();
            print("form submitted.");
          }
        },
        child: const Icon(Icons.search),
        // child: Icon(Icons.search),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snack(
      String message) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message.toString()),
      duration: const Duration(seconds: 4),
    ));
  }
}
