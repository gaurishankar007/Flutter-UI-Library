import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_ui/material_ui.dart';

class BaseFutureBuilder<T> extends HookWidget {
  const BaseFutureBuilder({
    super.key,
    required this.future,
    this.loadingWidget,
    this.errorBuilder,
    required this.dataBuilder,
  });
  final Future<T> Function() future;
  final Widget? loadingWidget;
  final Widget Function(Object? error, StackTrace? stackTrace)? errorBuilder;
  // The callback parameter needs to accept the generic type T produced by the future.
  // ignore: unsafe_variance
  final Widget Function(T data) dataBuilder;

  @override
  Widget build(BuildContext context) {
    final callback = useMemoized(future);
    final snapshot = useFuture(callback);

    if (snapshot.hasData) {
      final data = snapshot.data;
      if (data == null) {
        return const SizedBox.shrink();
      }
      return dataBuilder(data);
    } else if (snapshot.hasError) {
      return errorBuilder?.call(snapshot.error, snapshot.stackTrace) ??
          const SizedBox.shrink();
    } else {
      return loadingWidget ?? const SizedBox.shrink();
    }
  }
}
