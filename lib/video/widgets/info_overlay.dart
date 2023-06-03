import 'package:flutter/material.dart';

class InfoOverlay extends StatelessWidget {
  const InfoOverlay({
    this.onPressed,
    super.key,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 8,
      top: 8,
      child: IconButton(
        autofocus: true,
        icon: const Icon(Icons.info_outline),
        color: Colors.white,
        iconSize: 40,
        onPressed: onPressed,
      ),
    );
  }
}
