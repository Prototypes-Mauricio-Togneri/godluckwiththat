import 'package:logger/logger.dart';

class Log {
  const Log._();

  static final Logger logger = Logger();

  static void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      logger.d(message, error, stackTrace);

  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      logger.e(message, error, stackTrace);

  static void uncaughtError(Object error, StackTrace stackTrace) =>
      logger.e('Uncaught Error', error, stackTrace);
}
