import 'package:tensionplanet/components/base/building.dart';

class Efficiency {
  double timeWorking = 0;
  double timeTotal = 0;

  void update(Building building, double dt) {
    if (building.state.isWorking) {
      timeWorking += dt;
    }

    timeTotal += dt;

    final int efficiency = (((timeWorking / timeTotal) * 10).toInt()) * 10;
    building.efficiencyText.text = '$efficiency%';

    if (timeTotal > 60) {
      timeWorking = 0;
      timeTotal = 0;
    }
  }
}
