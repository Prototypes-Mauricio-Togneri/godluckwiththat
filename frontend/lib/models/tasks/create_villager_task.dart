class CreateVillagerTask {
  double remainingTime;

  CreateVillagerTask(this.remainingTime);

  bool update(double dt) {
    remainingTime -= dt;

    return remainingTime <= 0;
  }
}
