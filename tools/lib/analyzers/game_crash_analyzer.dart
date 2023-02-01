import 'dart:io';
import 'package:image/image.dart';
import 'package:tension_node_tools/analyzers/base_analyzer.dart';
import 'package:tension_node_tools/analyzers/heatmap.dart';
import 'package:tension_node_tools/json/json_analytic_event.dart';

class GameCrashAnalyzer extends BaseAnalyzer {
  const GameCrashAnalyzer() : super('game_crash');

  void run() {
    final List<GameCrash> list = events(GameCrash.fromJson);
    final Map<int, int> levelHeights = getLevelHeights(list);
    final Map<int, Heatmap> heatmaps = {};
    final Map<String, int> bodyMap = {};
    final Map<int, int> levelCrashMap = {};

    for (final GameCrash event in list) {
      if (heatmaps.containsKey(event.level)) {
        final Heatmap heatmap = heatmaps[event.level]!;
        heatmap.pointAbsolute(50, event.positionY, 10, getColor(255, 0, 0, 128));
      } else {
        final Heatmap heatmap = Heatmap(
          path: 'level_${event.level}.png',
          width: 100,
          height: levelHeights[event.level]! + 100,
        );

        heatmap.pointAbsolute(50, event.positionY, 10, getColor(255, 0, 0, 128));

        heatmaps[event.level] = heatmap;
      }

      if (event.validBodyId) {
        final String bodyId = '${event.level}.${event.body}';
        bodyMap[bodyId] = (bodyMap[bodyId] ?? 0) + 1;
        levelCrashMap[event.level] = (levelCrashMap[event.level] ?? 0) + 1;
      }
    }

    final file = File('levels_crashes.csv');
    file.writeAsString(_crashCsv(bodyMap, levelCrashMap));

    for (final Heatmap heatmap in heatmaps.values) {
      heatmap.write();
    }
  }

  String _crashCsv(Map<String, int> bodyMap, Map<int, int> levelCrashMap) {
    String resultText = 'enemy';

    for (int i = 1; i <= 30; i++) {
      resultText += ',$i';
    }

    resultText += '\n';

    for (int i = 1; i <= 54; i++) {
      resultText += 'e$i';

      for (int j = 1; j <= 30; j++) {
        final String key = '$j.e$i';
        final int crashes = bodyMap[key] ?? 0;

        resultText += ',$crashes';
      }

      resultText += '\n';
    }

    resultText += 'total';

    for (int i = 1; i <= 30; i++) {
      final int crashes = levelCrashMap[i] ?? 0;
      resultText += ',$crashes';
    }

    return resultText;
  }

  Map<int, int> getLevelHeights(List<GameCrash> list) {
    final Map<int, int> levelHeights = {};

    for (final GameCrash event in list) {
      if (levelHeights.containsKey(event.level)) {
        final current = levelHeights[event.level]!;

        if (event.positionY > current) {
          levelHeights[event.level] = event.positionY;
        }
      } else {
        levelHeights[event.level] = event.positionY;
      }
    }

    return levelHeights;
  }
}

class GameCrash {
  final int level;
  final int positionY;
  final String body;

  const GameCrash({
    required this.level,
    required this.positionY,
    required this.body,
  });

  bool get validBodyId => body.isNotEmpty && !body.contains('-');

  factory GameCrash.fromJson(JsonAnalyticEvent json) => GameCrash(
        level: json.get('level', 0),
        positionY: json.get('positionY', 0),
        body: json.get('body', ''),
      );
}
