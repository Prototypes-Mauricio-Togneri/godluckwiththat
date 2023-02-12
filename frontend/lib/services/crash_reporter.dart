import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:tensionnode/services/environment.dart';
import 'package:tensionnode/services/log.dart';

class CrashReporter {
  static void onError(Object error, StackTrace stackTrace) {
    if (Environment.hasCrashReports) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
    } else {
      Log.uncaughtError(error, stackTrace);
    }
  }
}
