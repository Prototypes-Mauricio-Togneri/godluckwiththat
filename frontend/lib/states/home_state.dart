import 'package:dafluta/dafluta.dart';
import 'package:godluckwiththat/utils/navigation.dart';

class HomeState extends BaseState {
  @override
  void onLoad() => Delayed.post(Navigation.matchScreen);

  void onContinue() {}

  void onSettings() {}

  void onInfo() {}
}
