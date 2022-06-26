import 'dart:math' as math;

import 'package:flutter/material.dart';

class RotateIconButton extends StatefulWidget {
  const RotateIconButton({
    super.key,
    required this.icon,
    this.isLoading = false,
    required this.onPressed,
  });

  final Widget icon;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  State<RotateIconButton> createState() => _RotateIconButtonState();
}

class _RotateIconButtonState extends State<RotateIconButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
      ),
    );

    super.initState();
  }

  @override
  void didUpdateWidget(covariant RotateIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _animationController.repeat();
      } else {
        _animationController.stop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        return Transform.rotate(
          angle:
              widget.isLoading ? _animationController.value * 2 * math.pi : 0,
          child: IconButton(
            icon: widget.icon,
            splashRadius: 24,
            onPressed: widget.onPressed,
          ),
        );
      },
    );
  }
}
