class Shooting {
  double accumulatedTime = 0;
  final double timeToShoot;

  Shooting(double fireRate) : timeToShoot = 1 / fireRate {
    accumulatedTime = timeToShoot;
  }

  void update(double dt) {
    accumulatedTime += dt;
    accumulatedTime = accumulatedTime.clamp(0, timeToShoot);
  }

  bool canShoot(double dt) {
    if (accumulatedTime >= timeToShoot) {
      accumulatedTime = 0;

      return true;
    } else {
      return false;
    }
  }
}
