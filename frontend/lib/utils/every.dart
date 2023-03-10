class Every {
  final double time;
  double delta = 0;

  Every(this.time);

  void update(double dt) {
    delta += dt;
  }

  bool get available {
    if (delta >= time) {
      delta = 0;

      return true;
    } else {
      return false;
    }
  }
}
