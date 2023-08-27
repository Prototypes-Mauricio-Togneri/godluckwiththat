class Task {
  double totalTime = 0;
  double remainingTime = 0;

  Task({
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
