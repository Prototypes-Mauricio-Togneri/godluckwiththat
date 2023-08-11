import 'package:dafluta/dafluta.dart';
import 'package:gatewayguardians/utils/navigation.dart';

class SplashState extends BaseState {
  @override
  Future onLoad() async {
    /*Authentication.checkIfAuthenticated(
      onSuccess: _onUserAuthenticated,
      onError: _onUserNotAuthenticated,
    );*/
    Navigation.homeScreen();
  }

  /*void _onUserAuthenticated(User user) {
    Navigation.homeScreen();
  }

  Future _onUserNotAuthenticated() async {
    final bool success = await Authentication.signUp();

    if (success) {
      Navigation.homeScreen();
    } else {
    }
  }*/
}
