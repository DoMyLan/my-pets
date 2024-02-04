import 'package:flutter/material.dart';
import 'package:found_adoption_application/custom_widget/input_widget.dart';

import 'package:found_adoption_application/screens/login_screen.dart';
import 'package:found_adoption_application/services/auth/signup_api.dart';
import 'package:found_adoption_application/utils/loading.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String signupType = 'USER';
  bool isValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        // brightness: Brightness.light,
        backgroundColor: const Color.fromRGBO(48, 96, 96, 1.0),
        title: Text('Back to Home'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Create an account, It's free ",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  // inputFile(label: "Username"),
                  inputField(label: "Email", controller: emailController, isPassword: false, isLogin: false),
                  inputField(
                      label: "Password",
                      obscureText: true,
                      controller: passwordController, isPassword: true, isLogin: false),

                  // inputField(label: "Confirm Password ", obscureText: true),

                  Card(
                    elevation: 7.0,
                    color: Colors.grey.shade300,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          15), // Điều này đặt độ bo tròn của góc
                      side: BorderSide(
                          color: const Color.fromRGBO(48, 96, 96, 1.0),
                          width:
                              2), // Điều này đặt màu và độ dày của đường viền
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Signup with Role:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  Radio<String>(
                                    value: 'USER',
                                    groupValue: signupType,
                                    onChanged: (value) {
                                      setState(() {
                                        signupType = value!;
                                      });
                                    },
                                  ),
                                  const Text("User"),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio<String>(
                                    value: 'CENTER',
                                    groupValue: signupType,
                                    onChanged: (value) {
                                      setState(() {
                                        signupType = value!;
                                      });
                                    },
                                  ),
                                  const Text("Pet Center"),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.only(top: 3, left: 3),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(48, 96, 96, 1.0),
                    borderRadius: BorderRadius.circular(50),
                    border: const Border(
                      bottom: BorderSide(color: Colors.black),
                      top: BorderSide(color: Colors.black),
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                    )),

                //BUTTON CONTINUE
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () async {
                    Loading(context);
                    await signup(context, emailController.text.toString(),
                        passwordController.text.toString(), signupType);
                    Navigator.of(context).pop();

                  },
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: const Text(
                      " Login",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
