import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

extension DurationExtension on Duration {
  /// Returns the duration in string format HH:MM:SS.
  String durationToHMS() {
    var hours = '$inHours';
    var minutes = '${inMinutes.remainder(60)}';
    var seconds = '${inSeconds.remainder(60)}';

    if (hours.length == 1) {
      hours = '0$hours';
    }
    if (minutes.length == 1) {
      minutes = '0$minutes';
    }
    if (seconds.length == 1) {
      seconds = '0$seconds';
    }

    return '$hours:$minutes:$seconds';
  }
}

class StopwatchTimer extends StatefulWidget {
  const StopwatchTimer({super.key, required this.stopwatch});
  final Stopwatch stopwatch;

  @override
  State<StopwatchTimer> createState() => _StopwatchTimerState();
}

class _StopwatchTimerState extends State<StopwatchTimer> {
  late Stopwatch stopwatch;
  late final Timer timer;
  String elapsedDuration = '';

  @override
  void initState() {
    super.initState();
    stopwatch = widget.stopwatch;
    elapsedDuration = stopwatch.elapsed.durationToHMS();
    startTimer();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant StopwatchTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stopwatch != oldWidget.stopwatch) {
      stopwatch = widget.stopwatch;
      setState(
        () => elapsedDuration = widget.stopwatch.elapsed.durationToHMS(),
      );
    }
  }

  @override
  Widget build(BuildContext context) => BaseText(elapsedDuration);

  /// Update stop watch elapsed time
  void startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) =>
          setState(() => elapsedDuration = stopwatch.elapsed.durationToHMS()),
    );
  }

  /// Stop updating stop watch elapsed time
  void stopTimer() => timer.cancel();
}
