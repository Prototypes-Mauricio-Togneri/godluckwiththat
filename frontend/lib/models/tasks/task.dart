import 'package:godluckwiththat/extensions/item_map_extension.dart';

class Task {
  double totalTime = 0;
  double remainingTime = 0;
  final ResourceMap cost;
  final int villagers;

  Task({
    required this.cost,
    required this.villagers,
    required double duration, // in days
  }) {
    totalTime = duration;
    remainingTime = totalTime;
  }

  double get progress => 1 - (remainingTime / totalTime);

  bool get isCompleted => remainingTime <= 0;

  bool update(double dt) {
    remainingTime -= dt;

    return isCompleted;
  }
}
