import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:gatewayguardians/utils/log.dart';

class ErrorHandler {
  static Future process(Object exception) {
    Log.error(exception.toString(), exception);

    return FirebaseCrashlytics.instance.recordError(
      exception,
      null,
      reason: exception.toString(),
    );
  }
}
