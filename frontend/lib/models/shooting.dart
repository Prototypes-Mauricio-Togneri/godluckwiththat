class Shooting {
  num accumulatedTime = 0;
  final num timeToShoot;

  Shooting(num fireRate) : timeToShoot = 1 / fireRate {
    accumulatedTime = timeToShoot;
  }

  void update(num dt) {
    accumulatedTime += dt;
    accumulatedTime = accumulatedTime.clamp(0, timeToShoot);
  }

  bool canShoot(num dt) {
    if (accumulatedTime >= timeToShoot) {
      accumulatedTime = 0;

      return true;
    } else {
      return false;
    }
  }
}
