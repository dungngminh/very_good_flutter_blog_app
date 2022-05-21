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
      clipBehavior: child is Icon ? Clip.antiAlias : Clip.none,
      child: Material(
        color: Colors.transparent,
        child: IconButton(
          padding: EdgeInsets.zero,
          splashRadius: child is Icon ? 20 : 26,
          icon: DecoratedBox(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: child,
            ),
          ),
          onPressed: onTapEvent,
        ),
      ),
    );
  }
}
