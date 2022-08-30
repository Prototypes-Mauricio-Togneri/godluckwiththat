class RenderTracker {
  static int linesRendered = 0;
  static int pathsRendered = 0;
  static int rectRendered = 0;
  static int circlesRendered = 0;

  static void reset() {
    linesRendered = 0;
    pathsRendered = 0;
    rectRendered = 0;
    circlesRendered = 0;
  }

  static void debug() => print(
      'Lines: $linesRendered Paths: $pathsRendered Rects: $rectRendered Circles: $circlesRendered Total: ${linesRendered + pathsRendered + rectRendered + circlesRendered}');
}
