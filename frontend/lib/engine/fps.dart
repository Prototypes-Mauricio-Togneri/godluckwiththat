import 'dart:collection';

class FPS {
  final int _windowSize = 60;
  final Queue<double> window = Queue();
  double _sum = 0;

  void update(double dt) {
    window.addLast(dt);
    _sum += dt;

    if (window.length > _windowSize) {
      _sum -= window.removeFirst();
    }
  }

  int fps() {
    try {
      return (window.isEmpty ? 0 : window.length / _sum).toInt();
    } catch (e) {
      return 0;
    }
  }
}
