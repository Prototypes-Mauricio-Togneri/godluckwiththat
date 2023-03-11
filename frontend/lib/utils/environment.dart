import 'package:flutter/foundation.dart';
import 'package:tensionplanet/utils/platform.dart';

class Environment {
  static const bool isDebug = kDebugMode;

  static const bool isProd = !isDebug;

  static final bool canShowBuildingIndicator = Platform.isDesktop;

  static final bool hasCrashReports = Platform.isMobileNative;

  static String environment() => isDebug ? 'dev' : 'prod';

  static String platform() => defaultTargetPlatform.name;

  static String mode() => Platform.isWeb ? 'web' : 'native';
}
