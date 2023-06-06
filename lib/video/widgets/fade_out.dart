import 'dart:async';

import 'package:flutter/material.dart';

class FadeOut extends StatefulWidget {
  const FadeOut({
    required this.child,
    super.key,
    this.duration = const Duration(milliseconds: 200),
    this.delay = Duration.zero,
    this.animate = false,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;
  final bool animate;

  @override
  State<FadeOut> createState() => _FadeOutState();
}

/// State class, where the magic happens
class _FadeOutState extends State<FadeOut> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  late Debouncer debouncer;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    animation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        curve: Curves.easeOut,
        parent: controller,
      ),
    );

    debouncer = Debouncer(duration: widget.delay);
  }

  @override
  void dispose() {
    controller.dispose();
    debouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.reset();
    debouncer.run(() {
      controller.forward();
    });

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: animation.value,
          child: widget.child,
        );
      },
    );
  }
}

class Debouncer {
  Debouncer({required this.duration});

  final Duration duration;
  Timer? _timer;

  void run(VoidCallback action) {
    cancel();
    _timer = Timer(duration, action);
  }

  void cancel() {
    _timer?.cancel();
  }
}
