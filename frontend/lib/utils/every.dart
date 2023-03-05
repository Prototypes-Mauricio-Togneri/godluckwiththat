class Every {
  final double time;
  double delta = 0;

  Every(this.time);

  bool update(double dt) {
    delta += dt;

    if (delta >= time) {
      delta -= time;

      return true;
    } else {
      return false;
    }
  }
}
