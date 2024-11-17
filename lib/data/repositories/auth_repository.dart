import 'package:firebase_auth/firebase_auth.dart';
import 'package:shattok/data/models/user_model.dart';

class AuthRepository {
   final FirebaseAuth _firebaseAuth;

  AuthRepository() : _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  

  Future<UserModel?> signIn(String email, String password) async {
  try {
    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    final user = userCredential.user;
    if (user != null) {
      return UserModel.fromFirebaseUser(user);
    }
    return null;
  } on FirebaseAuthException {
    rethrow; // Re-lanzar la excepción específica
  } catch (e) {
    throw Exception('Unexpected error: $e');
  }
}

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
