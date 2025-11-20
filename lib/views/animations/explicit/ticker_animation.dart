import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TickerAnimation extends StatefulWidget {
  const TickerAnimation({super.key});

  @override
  State<TickerAnimation> createState() => _TickerAnimationState();
}

class _TickerAnimationState extends State<TickerAnimation> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = Ticker(
      (Duration elapsed) {
        // This is callback which would get called on every new frame
        // with fresh new instance of elapsed duration since when the _ticker.start() has been invoked
        setState(() {
          _elapsed = elapsed;
        });
      },
    );

    // To start getting notifications
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _elapsed.inMinutes;
    final seconds = _elapsed.inSeconds;
    final milliSeconds = _elapsed.inMilliseconds;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Ticker Animation",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Tickers are scheduled to tick on every frame when started",
            ),
            const SizedBox(width: double.maxFinite, height: 20),
            Text(
              'M$minutes:S$seconds:ML$milliSeconds',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
