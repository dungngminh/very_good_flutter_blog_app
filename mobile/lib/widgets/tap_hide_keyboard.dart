import 'package:flutter/widgets.dart';

class TapHideKeyboard extends StatelessWidget {
  const TapHideKeyboard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: child,
    );
  }
}
