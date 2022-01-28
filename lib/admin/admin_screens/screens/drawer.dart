import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qb_admin/admin/admin_screens/screens/all_orders.dart';

import 'add_banners.dart';
import 'add_users.dart';
import 'all_categories.dart';
import 'all_luckydraw.dart';

class Drawers extends StatefulWidget {
  const Drawers({Key? key}) : super(key: key);

  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<Drawers> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
        color: Colors.black,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      image: AssetImage("assets/images/logo.png"),
                      fit: BoxFit.contain)),
              child: Text(""),
            ),
            const Divider(
              height: 25,
              color: Colors.transparent,
            ),
            Card(
              color: Colors.white,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Orders(),
                      ));
                },
                leading: const Icon(Icons.account_box),
                title: const Text('Order Information'),
                focusColor: Colors.white,
                enableFeedback: true,
                hoverColor: Colors.white,
              ),
            ),
            const Divider(
              height: 2,
              color: Colors.transparent,
            ),
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LuckyDraws(),
                      ));
                },
                leading: const Icon(Icons.accessibility_sharp),
                title: const Text('Lucky Draw'),
                focusColor: Colors.white,
                enableFeedback: true,
                hoverColor: Colors.white,
              ),
            ),
            const Divider(
              height: 2,
              color: Colors.transparent,
            ),
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Categories(),
                      ));
                },
                leading: const Icon(Icons.add_outlined),
                title: const Text('Categories'),
                focusColor: Colors.white,
                enableFeedback: true,
                hoverColor: Colors.white,
              ),
            ),
            const Divider(
              height: 2,
              color: Colors.transparent,
            ),
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserData(),
                      ));
                },
                leading: const Icon(Icons.airplay_sharp),
                title: const Text('User Data'),
                focusColor: Colors.white,
                enableFeedback: true,
                hoverColor: Colors.white,
              ),
            ),
            const Divider(
              height: 2,
              color: Colors.transparent,
            ),
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Banners(),
                      ));
                },
                leading: const Icon(Icons.add_outlined),
                title: const Text('Banners'),
                focusColor: Colors.white,
                enableFeedback: true,
                hoverColor: Colors.white,
              ),
            ),
            const Divider(
              height: 2,
              color: Colors.transparent,
            ),
            Card(
              child: ListTile(
                onTap: () async {
                  await FirebaseAuth.instance.setPersistence(Persistence.NONE);
                  FirebaseAuth.instance.signOut();
                },
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                focusColor: Colors.white,
                enableFeedback: true,
                hoverColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
