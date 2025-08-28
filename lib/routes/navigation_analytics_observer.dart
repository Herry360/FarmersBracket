import 'package:flutter/material.dart';

class NavigationAnalyticsObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    // TODO: Integrate with analytics (e.g., Firebase)
    debugPrint('Navigation: pushed ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    debugPrint('Navigation: popped ${route.settings.name}');
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    debugPrint('Navigation: removed ${route.settings.name}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    debugPrint('Navigation: replaced ${oldRoute?.settings.name} with ${newRoute?.settings.name}');
  }
}