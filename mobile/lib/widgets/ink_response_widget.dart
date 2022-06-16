import 'package:flutter/material.dart';

class InkEffectWidget extends StatelessWidget {
  const InkEffectWidget({
    super.key,
    required this.child,
    this.onTapEvent,
  });

  final Widget child;
  final VoidCallback? onTapEvent;

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
          onPressed: onTapEvent,
        ),
      ),
    );
  }
}
