enum BuildingState {
  idle,
  working;

  bool get isIdle => this == idle;

  bool get isWorking => this == working;
}
