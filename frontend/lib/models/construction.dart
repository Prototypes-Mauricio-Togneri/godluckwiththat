import 'package:gatewayguardians/models/patch.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/types/building_type.dart';

class Construction {
  final Zone zone;
  final Patch patch;
  final BuildingType buildingType;
  final int toLevel;
  double remainingTime = 0;

  Construction({
    required this.zone,
    required this.patch,
    required this.buildingType,
    required this.toLevel,
  }) {
    remainingTime = buildingType.constructionTime(toLevel);
  }

  void update(double dt) {
    remainingTime -= dt;

    if (remainingTime < 0) {
      //GameState.instance.onConstructionCompleted(this);
    }
  }
}
