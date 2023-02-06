import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tensionnode/services/error_handler.dart';

class Authentication {
  static User? currentUser() => FirebaseAuth.instance.currentUser;

  static String get userId => currentUser()?.uid ?? '';

  static bool get isAuthenticated => currentUser() != null;

  static Future? reload() => currentUser()?.reload();

  static void checkIfAuthenticated({
    required Function(User) onSuccess,
    required Function onError,
  }) {
    final Stream<User?> stream = FirebaseAuth.instance.authStateChanges();
    StreamSubscription? subscription;
    subscription = stream.listen((user) async {
      subscription?.cancel();

      if (user != null) {
        try {
          await user.reload();
          onSuccess(user);
        } catch (e) {
          ErrorHandler.process(e);

          onError();
        }
      } else {
        onError();
      }
    });
  }

  static Future<bool> signUp() async {
    try {
      final UserCredential user =
          await FirebaseAuth.instance.signInAnonymously();

      final DocumentReference doc =
          FirebaseFirestore.instance.collection('accounts').doc(user.user!.uid);
      doc.set({'foo': 'bar'});

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future signOut() => FirebaseAuth.instance.signOut();
}
