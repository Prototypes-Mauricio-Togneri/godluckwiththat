import 'package:dafluta/dafluta.dart';
import 'package:tensionnode/services/navigation.dart';

class SplashState extends BaseState {
  @override
  Future onLoad() async {
    await Future.delayed(const Duration(seconds: 1));
    Navigation.homeScreen();
  }
}
