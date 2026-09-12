import 'package:material_ui/material_ui.dart';

class WidgetView extends StatelessWidget {

  const WidgetView({
    super.key,
    this.title = 'Widget Preview',
    required this.widget,
  });
  final String title;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(child: widget),
        ),
      ),
    );
  }
}
