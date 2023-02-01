import 'package:tension_node_tools/analyzers/game_crash_analyzer.dart';
import 'package:tension_node_tools/analyzers/game_level_finished_analyzer.dart';
import 'package:tension_node_tools/analyzers/game_touch_analyzer.dart';

void main() {
  const GameCrashAnalyzer().run();
  const GameTouchAnalyzer().run();
  const GameLevelFinishedAnalyzer().run();
}
