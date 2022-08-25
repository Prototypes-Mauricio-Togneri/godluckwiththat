import 'package:dafluta/dafluta.dart';

class MapLoadedState extends BaseState {
  bool loaded = false;

  void setLoaded() {
    loaded = true;
    Delayed.post(notify);
  }
}
