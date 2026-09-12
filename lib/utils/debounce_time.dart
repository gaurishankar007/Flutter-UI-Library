import 'dart:async';

class DebounceTime {

  DebounceTime({required this.delay});

  DebounceTime.search() : delay = const Duration(milliseconds: 500);
  final Duration delay;
  Timer? _timer;

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void cancel() => _timer?.cancel();
}
