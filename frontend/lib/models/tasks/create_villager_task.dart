class CreateVillagerTask {
  double totalTime;
  double remainingTime = 0;

  CreateVillagerTask(this.totalTime) {
    remainingTime = totalTime;
  }

  double get progress => 1 - (remainingTime / totalTime);

  bool update(double dt) {
    remainingTime -= dt;

    return remainingTime <= 0;
  }
}
