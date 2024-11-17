import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String email;

  UserModel({required this.uid, required this.email});

  // method to convert a Map<String, dynamic> object to a UserModel object
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(uid: user.uid, email: user.email!);
  }
}
