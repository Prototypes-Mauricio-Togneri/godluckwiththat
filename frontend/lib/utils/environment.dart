import 'package:flutter/foundation.dart';
import 'package:godluckwiththat/utils/platform.dart';

class Environment {
  static const bool isDebug = kDebugMode;

  static const bool isProd = !isDebug;

  static final bool hasCrashReports = Platform.isMobileNative;

  static final bool hasSmallScreen = Platform.isMobile;

  static String environment() => isDebug ? 'dev' : 'prod';

  static String platform() => defaultTargetPlatform.name;

  static String mode() => Platform.isWeb ? 'web' : 'native';
}
