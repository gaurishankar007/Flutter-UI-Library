import 'package:flutter/cupertino.dart';

class CupertinoLoading extends StatelessWidget {
  final double? dimension;
  final Color? indicatorColor;

  const CupertinoLoading({super.key, this.dimension, this.indicatorColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: dimension,
      child: const Center(child: CupertinoActivityIndicator()),
    );
  }
}
