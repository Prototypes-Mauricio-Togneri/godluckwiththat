import 'dart:io';
import 'package:tension_node_tools/analyzers/base_analyzer.dart';
import 'package:tension_node_tools/json/json_analytic_event.dart';

class GameLevelFinishedAnalyzer extends BaseAnalyzer {
  const GameLevelFinishedAnalyzer() : super('game_levelFinished');

  void run() {
    final Map<int, GameLevelFinished> result = {};
    final List<GameLevelFinished> list = events(GameLevelFinished.fromJson);

    for (final GameLevelFinished event in list) {
      if (result.containsKey(event.level)) {
        final GameLevelFinished existing = result[event.level]!;
        existing.crashes += event.crashes;
        existing.time += event.time;
        existing.stars += event.stars;
        existing.coins += event.coins;
        existing.totalCount++;
      } else {
        result[event.level] = event;
        result[event.level]!.totalCount++;
      }
    }

    String resultText = 'level,crashes,time,stars,coins,count\n';

    for (final GameLevelFinished event in result.values) {
      resultText += '${event.toString()}\n';
    }

    final file = File('levels_summary.csv');
    file.writeAsString(resultText);
  }
}

class GameLevelFinished {
  final int level;
  int crashes;
  double time;
  int stars;
  int coins;
  int totalCount = 0;

  GameLevelFinished({
    required this.level,
    required this.crashes,
    required this.time,
    required this.stars,
    required this.coins,
  });

  @override
  String toString() =>
      '$level,${(crashes / totalCount).toStringAsFixed(1)},${(time / totalCount).toStringAsFixed(1)},${(stars / totalCount).toStringAsFixed(1)},${(coins / totalCount).toStringAsFixed(1)},$totalCount';

  factory GameLevelFinished.fromJson(JsonAnalyticEvent json) => GameLevelFinished(
        level: json.get<num>('level', 0).toInt(),
        crashes: json.get<num>('crashes', 0).toInt(),
        time: json.get<num>('time', 0).toDouble(),
        stars: json.get<num>('stars', 0).toInt(),
        coins: json.get<num>('coins', 0).toInt(),
      );
}
