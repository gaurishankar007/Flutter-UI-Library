import 'package:flutter/material.dart';

class WidgetView extends StatelessWidget {
  final String title;
  final Widget widget;

  const WidgetView({
    super.key,
    this.title = "Widget Preview",
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: widget),
        ),
      ),
    );
  }
}
