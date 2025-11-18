import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BaseFutureBuilder<T> extends HookWidget {
  final Future<T> Function() future;
  final Widget? loadingWidget;
  final Widget Function(Object? error, StackTrace? stackTrace)? errorBuilder;
  final Widget Function(T data) dataBuilder;

  const BaseFutureBuilder({
    super.key,
    required this.future,
    this.loadingWidget,
    this.errorBuilder,
    required this.dataBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final callback = useMemoized(() => future());
    final snapshot = useFuture(callback);

    if (snapshot.hasData) {
      final data = snapshot.data;
      if (data == null) return SizedBox.shrink();
      return dataBuilder(data);
    } else if (snapshot.hasError) {
      return errorBuilder?.call(snapshot.error, snapshot.stackTrace) ??
          SizedBox.shrink();
    } else {
      return loadingWidget ?? SizedBox.shrink();
    }
  }
}
