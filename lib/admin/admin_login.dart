import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qb_admin/admin/otp.dart';

// import 'admin_dash.dart';

class admin_Login extends StatefulWidget {
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const admin_Login());
  }

  const admin_Login({Key? key}) : super(key: key);

  @override
  _admin_LoginState createState() => _admin_LoginState();
}

// ignore: camel_case_types
class _admin_LoginState extends State<admin_Login> {
  String dropdownValue = '+923044766916';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey,
      child: Column(
        children: [
          Container(
            height: 200,
            width: 200,
            margin: const EdgeInsets.only(top: 65),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(500),
              child: Center(
                child: Image.asset('assets/images/logo.png'),
              ),
            ),
          ),
          const Divider(
            height: 50,
            color: Colors.transparent,
          ),
          SingleChildScrollView(
            child: SizedBox(
              width: (kIsWeb
                  ? MediaQuery.of(context).size.width / 3
                  : MediaQuery.of(context).size.width / 1.5),
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('admin_no')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: Text(
                                'Loading...',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: (kIsWeb ? 16 : 12),
                                ),
                              ),
                            );
                          }
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                            ),
                            margin: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 25,
                            ),
                            padding: const EdgeInsets.all(10.0),
                            width: MediaQuery.of(context).size.width * 0.30,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isDense: true,
                                isExpanded: false,
                                hint: const Text("Select"),
                                value: dropdownValue,
                                icon: const Icon(
                                  Icons.arrow_drop_down_circle,
                                  color: Colors.blue,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue.toString();
                                  });
                                },
                                items: snapshot.data!.docs.map((map) {
                                  return DropdownMenuItem<String>(
                                    value: map["ph"].toString(),
                                    child: Text(
                                      map["name"],
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                      const Divider(
                        height: 10,
                        color: Colors.transparent,
                      ),
                      SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OTP(phone: dropdownValue)));
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const dash_Board()));
                          },
                          child: SizedBox(
                            height: 50,
                            width: (kIsWeb
                                ? MediaQuery.of(context).size.width / 4
                                : MediaQuery.of(context).size.width / 1.5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Icon(Icons.send),
                                VerticalDivider(
                                  width: 10,
                                  color: Colors.transparent,
                                ),
                                Text("Send Verification")
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
