class Shooting {
  double accumulatedTime = 0;
  final double timeToShoot;

  Shooting(double fireRate) : timeToShoot = 1 / fireRate {
    accumulatedTime = timeToShoot;
  }

  bool canShoot(double dt) {
    accumulatedTime += dt;

    if (accumulatedTime > timeToShoot) {
      accumulatedTime -= timeToShoot;

      return true;
    } else {
      return false;
    }
  }
}
