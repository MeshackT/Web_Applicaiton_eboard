
class UserData{
  String? uid;
  String? email;


  //UserData({required this.uid, required email});


  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
    };
  }

}