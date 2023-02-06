import 'package:dafluta/dafluta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tensionnode/services/authentication.dart';
import 'package:tensionnode/services/navigation.dart';

class SplashState extends BaseState {
  @override
  void onLoad() {
    Authentication.checkIfAuthenticated(
      onSuccess: _onUserAuthenticated,
      onError: _onUserNotAuthenticated,
    );
  }

  void _onUserAuthenticated(User user) {
    Navigation.homeScreen();
  }

  Future _onUserNotAuthenticated() async {
    final bool success = await Authentication.signUp();

    if (success) {
      Navigation.homeScreen();
    } else {
      // TODO(momo): show error
    }
  }
}
