class Shooting {
  num _accumulatedTime = 0;
  final num _timeToShoot;

  Shooting(num fireRate) : _timeToShoot = 1 / fireRate {
    _accumulatedTime = _timeToShoot;
  }

  void update(num dt) {
    _accumulatedTime += dt;
    _accumulatedTime = _accumulatedTime.clamp(0, _timeToShoot);
  }

  bool canShoot(num dt) {
    if (_accumulatedTime >= _timeToShoot) {
      _accumulatedTime = 0;

      return true;
    } else {
      return false;
    }
  }
}
