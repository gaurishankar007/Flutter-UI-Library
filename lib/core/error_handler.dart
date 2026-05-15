import 'dart:developer' show log;

import 'package:flutter/foundation.dart' show kDebugMode;

abstract final class ErrorHandler {
  /// Run an async callback and log any exceptions (does not rethrow).
  ///
  /// Use this to execute `Future`-returning code where errors should be
  /// logged for diagnostics but not propagated.
  static Future<void> executeSafe(Future<void> Function() callBack) async {
    try {
      await callBack();
    } catch (error, stackTrace) {
      _debugError(error, stackTrace);
    }
  }

  /// Run an async callback that returns `T`, logging exceptions.
  ///
  /// On error this returns the provided `valueOnError` fallback.
  static Future<T> executeSafeReturn<T>(
    Future<T> Function() callBack, {
    required T valueOnError,
  }) async {
    try {
      return await callBack();
    } catch (error, stackTrace) {
      _debugError(error, stackTrace);
      return valueOnError;
    }
  }

  /// Run a synchronous callback and log any exceptions (no rethrow).
  static void executeSafeSync(void Function() callBack) {
    try {
      callBack();
    } catch (error, stackTrace) {
      _debugError(error, stackTrace);
    }
  }

  /// Run a synchronous callback that returns `T`, logging exceptions.
  ///
  /// On error this returns the provided `valueOnError` fallback.
  static T executeSafeReturnSync<T>(
    T Function() callBack, {
    required T valueOnError,
  }) {
    try {
      return callBack();
    } catch (error, stackTrace) {
      _debugError(error, stackTrace);
      return valueOnError;
    }
  }

  /// Internal logger used to print caught exceptions in debug mode
  /// and record them to Firebase Crashlytics in production.
  static void _debugError(Object? error, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      log(
        '<--------- Caught Exception ---------->',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
