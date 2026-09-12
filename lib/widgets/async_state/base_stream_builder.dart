import 'package:material_ui/material_ui.dart';

class BaseStreamBuilder<T> extends StatelessWidget {

  const BaseStreamBuilder({
    super.key,
    required this.stream,
    required this.builder,
    this.errorBuilder,
    this.loadingWidget,
  });
  final Stream<T> stream;
  // The builder callback needs to accept the generic type T emitted by the stream.
  // ignore: unsafe_variance
  final Widget Function(T data) builder;
  final Widget? Function(Object? error)? errorBuilder;
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        const emptyWidget = SizedBox.shrink();

        if (snapshot.hasData) {
          final data = snapshot.data;
          return data == null ? emptyWidget : builder(data);
        } else if (snapshot.hasError) {
          return errorBuilder?.call(snapshot.error) ?? emptyWidget;
        }

        return loadingWidget ?? emptyWidget;
      },
    );
  }
}
