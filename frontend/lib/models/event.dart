import 'package:godluckwiththat/models/tasks/exploration_task.dart';
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
        menuType: MenuType.fromExploration(task),
      );
}
