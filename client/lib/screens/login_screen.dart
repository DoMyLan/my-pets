import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:found_adoption_application/services/auth/loginApi.dart';
import 'package:found_adoption_application/screens/signUp_screen.dart';
import 'package:found_adoption_application/custom_widget/input_widget.dart';
import 'package:found_adoption_application/utils/loading.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        // brightness: Brightness.light,
        backgroundColor: Color.fromRGBO(48, 96, 96, 1.0),
        leading: const Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Color.fromRGBO(48, 96, 96, 1.0),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Login to your account",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      inputField(
                          label: "Email",
                          controller: emailController,
                          isPassword: false,
                          isLogin: true),
                      inputField(
                          label: "Password",
                          obscureText: true,
                          controller: passwordController,
                          isPassword: true,
                          isLogin: true)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    padding: EdgeInsets.only(top: 3, left: 3),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(48, 96, 96, 1.0),
                        borderRadius: BorderRadius.circular(50),
                        border: Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                        )),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () async {
                        // final emailRegisterBox =
                        //     await Hive.openBox('emailRegisterBox');

                        // Kiểm tra giá trị của signUpType và thực hiện các hành động tương ứng
                        if (emailController.text.toString() == '') {
                          Fluttertoast.showToast(
                            msg: "Email not empty!",
                            toastLength:
                                Toast.LENGTH_SHORT, // Thời gian hiển thị
                            gravity: ToastGravity.BOTTOM, // Vị trí hiển thị
                            timeInSecForIosWeb:
                                1, // Thời gian hiển thị cho iOS và web
                            backgroundColor: Colors.grey, // Màu nền của toast
                            textColor: Colors.white, // Màu chữ của toast
                            fontSize: 16.0, // Kích thước chữ của toast
                          );
                        } else if (passwordController.text.toString() == '') {
                          Fluttertoast.showToast(
                            msg: "Password not empty!",
                            toastLength:
                                Toast.LENGTH_SHORT, // Thời gian hiển thị
                            gravity: ToastGravity.BOTTOM, // Vị trí hiển thị
                            timeInSecForIosWeb:
                                1, // Thời gian hiển thị cho iOS và web
                            backgroundColor: Colors.grey, // Màu nền của toast
                            textColor: Colors.white, // Màu chữ của toast
                            fontSize: 16.0, // Kích thước chữ của toast
                          );
                        } else {
                          Loading(context);
                          await login(
                            context,
                            emailController.text.toString(),
                            passwordController.text.toString(),
                          );
                        }
                      },
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              TextEditingController _controller =
                                  TextEditingController();
                              return AlertDialog(
                                title: const Text('Forgot Password'),
                                content: TextField(
                                  controller: _controller,
                                  decoration: const InputDecoration(
                                    labelText: 'Enter your email',
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Forgot Password'),
                                    onPressed: () async {
                                      String email = _controller
                                          .text; // Get value from text field

                                      Loading(context);
                                      await forgotPassword(
                                          email); // Call the forgotPassword function
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text(
                          "Forgot password?",
                          style: TextStyle(
                              fontSize: 17,
                              color: Color.fromARGB(255, 1, 64, 93),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontStyle: FontStyle.italic),
                        )),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 17, color: Colors.black),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()));
                      },
                      child: Text(
                        " Sign up",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 100),
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/background.png"),
                        fit: BoxFit.fitHeight),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
