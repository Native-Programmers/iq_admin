import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qb_admin/admin/admin_dash.dart';
import 'package:qb_admin/admin/admin_login.dart';
import 'package:qb_admin/models/user.dart';
import 'package:qb_admin/services/AuthController.dart';

class Wrapper extends StatelessWidget {
  static const String routeName = '/wrapper';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => const Wrapper());
  }

  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<Users?>(
        stream: authService.user,
        builder: (_, AsyncSnapshot<Users?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final Users? user = snapshot.data;
            return user != null ? const dash_Board() : const admin_Login();
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
