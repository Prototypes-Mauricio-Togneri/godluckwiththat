import 'package:godluckwiththat/extensions/resource_map_extension.dart';

class Task {
  final ResourceMap cost;
  double totalTime = 0;
  double remainingTime = 0;

  Task({
    required this.cost,
  }) {
    totalTime = cost.time;
    remainingTime = totalTime;
  }

  double get progress => 1 - (remainingTime / totalTime);

  bool update(double dt) {
    remainingTime -= dt;

    return remainingTime <= 0;
  }
}
