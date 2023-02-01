// ignore_for_file: avoid_print

import 'package:image/image.dart';
import 'package:tension_node_tools/analyzers/base_analyzer.dart';
import 'package:tension_node_tools/analyzers/heatmap.dart';
import 'package:tension_node_tools/json/json_analytic_event.dart';

class GameTouchAnalyzer extends BaseAnalyzer {
  const GameTouchAnalyzer() : super('game_touch');

  static const int width = 1000;
  static const int height = 1700;

  void run() {
    final List<GameTouch> list = events(GameTouch.fromJson);

    int sumX = 0;
    int sumY = 0;

    final Heatmap heatmap = Heatmap(
      path: 'touch.png',
      width: width,
      height: height,
    );

    for (final GameTouch event in list) {
      sumX += event.positionX;
      sumY += event.positionY;

      heatmap.pointPercentage(event.positionX, event.positionY, 20, getColor(255, 0, 0, 128));
    }

    final int averageX = sumX ~/ list.length;
    final int averageY = sumY ~/ list.length;

    heatmap.pointPercentage(averageX, averageY, 20, getColor(0, 255, 0, 255));
    heatmap.write();
  }
}

class GameTouch {
  final int positionX;
  final int positionY;

  const GameTouch({
    required this.positionX,
    required this.positionY,
  });

  factory GameTouch.fromJson(JsonAnalyticEvent json) => GameTouch(
        positionX: json.get('positionX', 0),
        positionY: json.get('positionY', 0),
      );
}
