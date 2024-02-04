import 'dart:async';

import 'package:flutter/material.dart';
import 'package:found_adoption_application/custom_widget/time_countdown.dart';
import 'package:found_adoption_application/screens/pet_center_screens/register_form.dart';
import 'package:found_adoption_application/screens/user_screens/registration_form.dart';
import 'package:found_adoption_application/services/auth/signup_api.dart';

import 'package:hive/hive.dart';

class ShowOTPInputDialog extends StatefulWidget {
  const ShowOTPInputDialog(
      {super.key, required this.storedEmail, required this.signUpType});

  final String storedEmail;
  final String signUpType;

  @override
  State<ShowOTPInputDialog> createState() => _ShowOTPInputDialogState();
}

class _ShowOTPInputDialogState extends State<ShowOTPInputDialog> {
  int remainingTime = 300; // 5 minutes in seconds
  late Timer timer;
  bool timeIsUp = false; // Flag to indicate if the time is up
  int filledCount = 0; // Đếm số ô đã được điền
  List<TextEditingController> controllers =
      List.generate(6, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel(); // Stop the timer when it reaches zero
        setState(() {
          timeIsUp = true; // Set the timeIsUp flag
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(203, 213, 216, 1),
      // resizeToAvoidBottomInset: false,
      body: AlertDialog(
        backgroundColor: Colors.grey.shade200,
        contentPadding: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: const Center(
          child: Text(
            "OTP Verification",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 30,
            ),
          ),
        ),
        content: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                  "Enter the 6 digit verification code received on your Email ID."),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    "Verification code",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  filledCount == 6
                      ? const Icon(
                          Icons
                              .check, // Sử dụng biểu tượng tích xanh khi đã điền đủ 6 ô
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons
                              .error_outline, // Sử dụng biểu tượng dấu chấm than (!) khi chưa điền đủ 6 ô
                          color: Colors.red,
                        ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      // Xử lý khi bấm nút "Resend OTP"
                      resendcode(widget.storedEmail);
                    },
                    child: const Text("Resend OTP",
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return Container(
                    width: 36,
                    child: TextField(
                      controller: controllers[index],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(context).nextFocus();
                        }
                        if (value.isNotEmpty) {
                          filledCount++;
                        } else {
                          filledCount--;
                        }
                      },
                    ),
                  );
                }),
              ),
              countdownTimer(context, remainingTime, timer, timeIsUp),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (filledCount == 6) {
                    String otp =
                        controllers.map((controller) => controller.text).join();

                    bool verificationResult =
                        await verifycode(widget.storedEmail, otp);

                    if (verificationResult == true) {
                      if (widget.signUpType == 'USER') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrationForm(accountId: '',)));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RegistrationCenterForm()));
                      }
                    }
                  }
                },
                child: const Text(
                  'Verify',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void showOTPInputDialog(BuildContext context) async {
  final emailRegisterBox = await Hive.openBox('emailRegisterBox');
  final storedEmail = emailRegisterBox.get('email') as String;
  final signUpType = emailRegisterBox.get('role') as String;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ShowOTPInputDialog(
        storedEmail: storedEmail,
        signUpType: signUpType,
      );
    },
  );
}
