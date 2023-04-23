// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseRegistrationHelper {
  FirebaseRegistrationHelper._();
  static final FirebaseRegistrationHelper firebaseRegistrationHelper =
      FirebaseRegistrationHelper._();

  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static GoogleSignIn googleSignIn = GoogleSignIn();

  String getCurrentUserId() {
    return firebaseAuth.currentUser!.uid;
  }

  Future<User?> signUp(
      {required String email, required String password}) async {
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    return userCredential.user;
  }

  Future<User?> signIn(
      {required String email, required String password}) async {
    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    return userCredential.user;
  }

  Future<void> signOutUser() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    return userCredential.user;
  }

  Future<void> updateUserName({required String name}) async {
    User? user = firebaseAuth.currentUser;
    user!.updateDisplayName(name);
  }

  Future<void> updatePhoneNumber({required PhoneAuthCredential number}) async {
    User? user = firebaseAuth.currentUser;
    user!.updatePhoneNumber(number);
  }

  Future<void> updateEmail({required String email}) async {
    User? user = firebaseAuth.currentUser;
    user!.updateEmail(email);
  }

  Future<User?> currentUser() async {
    return firebaseAuth.currentUser;
  }
}
