import 'dart:async';

class DebounceTime {
  final Duration delay;
  Timer? _timer;

  DebounceTime({required this.delay});

  DebounceTime.search() : delay = Duration(milliseconds: 500);

  void run(Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void cancel() => _timer?.cancel();
}
