enum ActionType {
  explore(passTurn: true),
  claim(passTurn: true),
  train(passTurn: false),
  build(passTurn: true),
  levelUp(passTurn: true),
  destroy(passTurn: true),
  attack(passTurn: true);

  final bool passTurn;

  const ActionType({
    required this.passTurn,
  });
}
