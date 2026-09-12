import 'package:flutter/cupertino.dart';

class CupertinoLoading extends StatelessWidget {

  const CupertinoLoading({super.key, this.dimension, this.indicatorColor});
  final double? dimension;
  final Color? indicatorColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: dimension,
      child: const Center(child: CupertinoActivityIndicator()),
    );
  }
}
