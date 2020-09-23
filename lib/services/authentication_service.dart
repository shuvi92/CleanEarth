import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:timwan/locator.dart';
import 'package:timwan/models/user.dart';
import 'package:timwan/services/firestore_service.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirestoreService _firestoreService = locator<FirestoreService>();

  User _currentUser;
  User get currentUser => _currentUser;

  bool _isUserAnonymous = false;
  bool get isUserAnonymous => _isUserAnonymous;

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(
      uid: user.uid,
      email: user.email,
      fullName: user.displayName,
      photoUrl: user.photoUrl,
    );
  }

  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  Future signInWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _populateCurrentUser(authResult.user);
      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future signUpWithEmail({
    @required String email,
    @required String password,
    @required String fullName,
  }) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // create a new user profile on firestore
      _currentUser = User(
        uid: authResult.user.uid,
        email: email,
        fullName: fullName,
        photoUrl: authResult.user.photoUrl,
      );

      await _firestoreService.createUser(_currentUser);

      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future signInAnonymously() async {
    try {
      var authResult = await _firebaseAuth.signInAnonymously();

      // create a new user profile on firestore
      _currentUser = User(
        uid: authResult.user.uid,
        email: "",
        fullName: 'Anonymous',
        photoUrl: "",
      );

      await _firestoreService.createUser(_currentUser);
      _isUserAnonymous = authResult.user.isAnonymous;

      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    await _firebaseAuth.signOut();
    _currentUser = null;
  }

  Future<bool> isUserLoggedIn() async {
    var user = await _firebaseAuth.currentUser();
    _isUserAnonymous = user?.isAnonymous ?? false;
    await _populateCurrentUser(user);
    return user != null;
  }

  Future _populateCurrentUser(FirebaseUser user) async {
    if (user != null) {
      _currentUser = await _firestoreService.getUser(user.uid);
    }
  }
}
