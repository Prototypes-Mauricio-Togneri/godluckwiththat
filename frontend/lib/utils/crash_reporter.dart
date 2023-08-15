import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:godluckwiththat/utils/environment.dart';
import 'package:godluckwiththat/utils/log.dart';

class CrashReporter {
  static void onError(Object error, StackTrace stackTrace) {
    if (Environment.hasCrashReports) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
    } else {
      Log.uncaughtError(error, stackTrace);
    }
  }
}
