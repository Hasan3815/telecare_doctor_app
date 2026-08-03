import 'dart:developer';

class AppLogger {
  AppLogger._();

  static void info(
    String message,
  ) {
    log(
      message,
      name: 'TeleCare',
    );
  }

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(
      message,
      name: 'TeleCare',
      error: error,
      stackTrace: stackTrace,
    );
  }
}