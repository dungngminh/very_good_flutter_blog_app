import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

extension ContextExtension on BuildContext {
  EdgeInsets get padding {
    return MediaQuery.of(this).padding;
  }

  double get screenWidth {
    return MediaQuery.of(this).size.width;
  }

  double get screenHeight {
    return MediaQuery.of(this).size.height;
  }

  String get currentLocation {
    return GoRouter.of(this).location;
  }
}
