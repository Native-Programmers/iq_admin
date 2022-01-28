import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qb_admin/admin/admin_dash.dart';

// ignore: must_be_immutable
class OTP extends StatelessWidget {
  final String phone;
  OTP({Key? key, required this.phone}) : super(key: key);

  String? _enteredOTP;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FirebasePhoneAuthHandler(
        phoneNumber: phone,
        timeOutDuration: const Duration(seconds: 60),
        onLoginSuccess: (userCredential, autoVerified) async {
          // context.read<AdminLogin>().setUser(userCredential.user!.uid);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const dash_Board()));
        },
        onLoginFailed: (authException) {
          print("An error occurred: ${authException.message}");
          showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error occured'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(authException.message.toString()),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Try Again'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        builder: (context, controller) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Verification Code"),
              backgroundColor: Colors.black,
              actions: controller.codeSent
                  ? [
                      TextButton(
                        child: Text(
                          controller.timerIsActive
                              ? "${controller.timerCount.inSeconds}s"
                              : "RESEND",
                          style:
                              const TextStyle(color: Colors.blue, fontSize: 18),
                        ),
                        onPressed: controller.timerIsActive
                            ? null
                            : () async {
                                await controller.sendOTP();
                              },
                      ),
                      const SizedBox(width: 5),
                    ]
                  : null,
            ),
            body: controller.codeSent
                ? ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      const SizedBox(height: 10),
                      const Divider(),
                      AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        height: controller.timerIsActive ? null : 0,
                        child: Column(
                          children: const [
                            CircularProgressIndicator(),
                            SizedBox(height: 50),
                            Text(
                              "Listening for OTP",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        "Enter Code Manually",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Type OTP Here...',
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white70,
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                        ],
                        onSubmitted: (String v) async {
                          _enteredOTP = v;
                          if (_enteredOTP?.length == 6) {
                            final res =
                                await controller.verifyOTP(otp: _enteredOTP!);

                            if (!res) {
                              print("try again");
                            }
                          }
                        },
                        onChanged: (String v) async {
                          _enteredOTP = v;
                          if (_enteredOTP?.length == 6) {
                            final res =
                                await controller.verifyOTP(otp: _enteredOTP!);
                            // Incorrect OTP
                            if (!res) {
                              print(
                                "Please enter the correct OTP sent to $phone",
                              );
                            }
                          }
                        },
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 50),
                      Center(
                        child: Text(
                          "Sending OTP",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ],
                  ),
            floatingActionButton: controller.codeSent
                ? FloatingActionButton(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: const Icon(Icons.check),
                    onPressed: () async {
                      if (_enteredOTP == null || _enteredOTP?.length != 6) {
                        print("Please enter a valid 6 digit OTP");
                      } else {
                        final res =
                            await controller.verifyOTP(otp: _enteredOTP!);
                        // Incorrect OTP
                        if (!res) {
                          print("try again");
                        }
                      }
                    },
                  )
                : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }
}
