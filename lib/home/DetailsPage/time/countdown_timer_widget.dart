// lib/home/DetailsPage/time/countdown_timer_widget.dart

import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimerWidget extends StatefulWidget {
  final DateTime targetTime;
  final VoidCallback? onCountdownComplete;

  const CountdownTimerWidget({
    Key? key,
    required this.targetTime,
    this.onCountdownComplete,
  }) : super(key: key);

  @override
  _CountdownTimerWidgetState createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late Timer _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _updateRemainingTime();
    _startTimer();
  }

  void _updateRemainingTime() {
    final now = DateTime.now();
    setState(() {
      _remaining = widget.targetTime.difference(now);
      if (_remaining.isNegative) {
        _remaining = Duration.zero;
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      _updateRemainingTime();
      if (_remaining == Duration.zero) {
        _timer.cancel();
        if (widget.onCountdownComplete != null) {
          widget.onCountdownComplete!();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(_remaining),
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: _remaining > Duration(minutes: 10) ? Colors.green : Colors.red,
      ),
    );
  }
}
