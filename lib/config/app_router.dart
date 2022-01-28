import 'package:flutter/material.dart';
import 'package:qb_admin/error/error.dart';
import 'package:qb_admin/extension/string_extension.dart';
import 'package:qb_admin/wrapper/wrapper.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    var routingData = settings.name?.getRoutingData;

    print('This is the route name ${settings.name}');
    switch (settings.name) {
      case Wrapper.routeName:
        return Wrapper.route();
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => const Scaffold(
        body: Errors(),
      ),
    );
  }
}
