import 'package:dafluta/dafluta.dart';
import 'package:godluckwiththat/utils/navigation.dart';

class SplashState extends BaseState {
  @override
  void onLoad() => Delayed.post(Navigation.homeScreen);
}
