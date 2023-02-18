enum BuildingState {
  idle,
  producing,
  finished;

  bool get isIdle => this == idle;

  bool get isProducing => this == producing;

  bool get isFinished => this == finished;
}
