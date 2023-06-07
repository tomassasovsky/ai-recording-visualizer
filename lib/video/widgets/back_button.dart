import 'package:flutter/material.dart';

class CloseVideo extends StatelessWidget {
  const CloseVideo({
    this.onPressed,
    super.key,
  });

  final Future<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: FloatingActionButton(
        onPressed: () async {
          await onPressed?.call();
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
        heroTag: 'back',
        backgroundColor: Colors.transparent,
        hoverElevation: 0,
        elevation: 0,
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
