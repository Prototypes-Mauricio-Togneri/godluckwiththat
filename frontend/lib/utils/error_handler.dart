import 'package:godluckwiththat/utils/environment.dart';
import 'package:godluckwiththat/utils/log.dart';

class ErrorHandler {
  static Future process(Object exception) {
    Log.error(exception.toString(), exception);

    /*return FirebaseCrashlytics.instance.recordError(
      exception,
      null,
      reason: exception.toString(),
    );*/

    return Future.value();
  }

  static void onError(Object error, StackTrace stackTrace) {
    if (Environment.hasCrashReports) {
      //FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
    } else {
      Log.uncaughtError(error, stackTrace);
    }
  }
}
