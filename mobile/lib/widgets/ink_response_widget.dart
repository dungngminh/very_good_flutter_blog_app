import 'package:flutter/material.dart';

class InkEffectIconButton extends StatelessWidget {
  const InkEffectIconButton({
    super.key,
    required this.child,
    this.onPressed,
  });

  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: IconButton(
          padding: EdgeInsets.zero,
          splashRadius: 20,
          icon: DecoratedBox(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: child,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
