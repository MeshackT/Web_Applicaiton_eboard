import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static Future<List<User>> getAllUserProfiles() async {
    try {
      final List<User> users = [];
      final authSubscription =
          _firebaseAuth.authStateChanges().listen((User? user) {
        if (user != null) {
          users.add(user);
          print(user);
        }
      });

      await Future.delayed(Duration(seconds: 1));
      authSubscription.cancel();
      return users;
    } catch (e) {
      print('Error retrieving user profiles: $e');
      return [];
    }
  }
}
