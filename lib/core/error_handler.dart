import 'dart:developer' show log;

import 'package:flutter/foundation.dart' show kDebugMode;

abstract final class ErrorHandler {
  static Future<void> executeSafe(Future<void> Function() callBack) async {
    try {
      await callBack();
    } catch (error, stackTrace) {
      _debugError(error, stackTrace);
    }
  }

  static Future<T> executeSafeReturn<T>(
    Future<T> Function() callBack, {
    required T Function(Object error, StackTrace stackTrace) onError,
  }) async {
    try {
      return await callBack();
    } catch (error, stackTrace) {
      _debugError(error, stackTrace);
      return onError(error, stackTrace);
    }
  }

  static void executeSafeSync(void Function() callBack) {
    try {
      callBack();
    } catch (error, stackTrace) {
      _debugError(error, stackTrace);
    }
  }

  static T executeSafeReturnSync<T>(
    T Function() callBack, {
    required T Function(Object error, StackTrace stackTrace) onError,
  }) {
    try {
      return callBack();
    } catch (error, stackTrace) {
      _debugError(error, stackTrace);
      return onError(error, stackTrace);
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
