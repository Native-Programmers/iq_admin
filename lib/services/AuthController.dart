import 'package:firebase_auth/firebase_auth.dart';
import 'package:qb_admin/models/user.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Users? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return Users(user.uid, user.email);
  }

  Stream<Users?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }
}
