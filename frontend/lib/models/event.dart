import 'package:godluckwiththat/models/tasks/construction_task.dart';
import 'package:godluckwiththat/models/tasks/exploration_task.dart';
import 'package:godluckwiththat/models/tasks/upgrade_building_task.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/menu_type.dart';

class Event {
  final String title;
  final MenuType menuType;

  const Event._({
    required this.title,
    required this.menuType,
  });

  factory Event.explorationFinished(ExplorationTask task) => Event._(
        title: '${task.patchType.toString()} exploration finished',
        menuType: MenuType.fromPatchType(task.patchType),
      );

  factory Event.constructionFinished(ConstructionTask task) => Event._(
        title: '${task.buildingType.toString()} construction finished',
        menuType: MenuType.fromBuildingType(task.buildingType),
      );

  factory Event.buildingUpgradeFinished(UpgradeBuildingTask task) => Event._(
        title: '${task.building.buildingType.toString()} upgrade finished',
        menuType: MenuType.fromBuildingType(task.building.buildingType),
      );

  factory Event.buildingDepleted(BuildingType buildingType) => Event._(
        title: '${buildingType.toString()} depleted',
        menuType: MenuType.fromBuildingType(buildingType),
      );

  factory Event.villagerFinished() => const Event._(
        title: 'A new villager has been created',
        menuType: MenuType.headquarters,
      );
}
