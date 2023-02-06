import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tensionnode/services/database.dart';
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
      final UserCredential credential =
          await FirebaseAuth.instance.signInAnonymously();
      await Database.createUser(credential.user!.uid);

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future signOut() => FirebaseAuth.instance.signOut();
}
