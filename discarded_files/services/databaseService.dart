import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;
  DatabaseService({required this.uid});
  //this enables us to manipulate data from documents in fire-store
  //CRUD enabled by this Reference
  final CollectionReference collectionReference = FirebaseFirestore.instance
                                                  .collection("teachersDetails");
  
  Future updateUserData(String grade, String subject, String nameSurname,) async{
    return await  collectionReference.doc(uid).set({
      'nameSurname': nameSurname,
      'grade': grade,
      'subject': subject,
      'uid':uid,
    });
  }

  //get teachers stream
  Stream<QuerySnapshot> get teachers{
    return collectionReference.snapshots();
  }
}