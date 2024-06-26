import 'package:flutter/material.dart';
import 'package:found_adoption_application/services/auth/change_password.dart';
import 'package:found_adoption_application/utils/loading.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';

class UpdatePasswordScreen extends StatefulWidget {
  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  TextEditingController password = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  bool isPasswordValid = true;
  bool isValidate = false;
  bool isButtonEnabled = false;
  bool _isObscure = true;
  bool _isObscure2 = true;
  bool _isObscure3 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 70,
          ),
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.lock_open,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Đổi mật khẩu',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Đảm bảo rằng bạn nhớ chính xác mật khẩu của bạn',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: password,
                    focusNode: myFocusNode,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu hiện tại',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                    onChanged: (value) => setState(() {
                      if (isValidate && isPasswordValid && password.text != "")
                        isButtonEnabled = true;
                    }),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        Pattern pattern =
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
                        RegExp regex = new RegExp(pattern.toString());
                        if (!regex.hasMatch(value))
                          isValidate = false;
                        else
                          isValidate = true;

                        if (isValidate &&
                            isPasswordValid &&
                            password.text != "") isButtonEnabled = true;
                        if (newPassword.text != confirmPassword.text) {
                          isPasswordValid = false;
                        } else
                          isPasswordValid = true;
                      });
                    },
                    controller: newPassword,
                    obscureText: _isObscure2,
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu mới',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure2 ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure2 = !_isObscure2;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      errorText: isValidate
                          ? null
                          : 'Mật khẩu phải có ít nhất 8 kí tự, bao gồm chứ in thường, \nchữ in hoa và chữ số', // Show error text when the password is not valid
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        isPasswordValid = value == newPassword.text;
                        if (isPasswordValid) {
                          confirmPassword.text = value;
                        }

                        if (isValidate &&
                            isPasswordValid &&
                            password.text != "") isButtonEnabled = true;
                      });
                    },
                    controller: confirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Xác nhận mật khẩu mới',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure3 ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure3 = !_isObscure3;
                          });
                        },
                      ),
                      errorText: isPasswordValid
                          ? null
                          : 'Mật khẩu không trùng khớp', // Show error text when the password is not valid
                    ),
                    obscureText: _isObscure3,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: isValidate && isPasswordValid && password.text != ""
                              ? Theme.of(context).primaryColor
                              : Colors.grey, disabledForegroundColor: Colors.grey.withOpacity(0.38), disabledBackgroundColor: Colors.grey.withOpacity(0.12),
                      fixedSize: Size.fromHeight(60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50), 
                      ),
                    ),
                    onPressed: isValidate &&
                            isPasswordValid &&
                            password.text != ""
                        ? () async {
                            if (password.text == "" ||
                                newPassword.text == "" ||
                                confirmPassword.text == "") {
                              notification(
                                  "Vui lòng điền đầy đủ thông tin!", true);
                            } else {
                              Loading(context);
                              bool success = await changePassword(
                                  password.text, newPassword.text);
                              Navigator.of(context).pop();
                              if (success) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              } else {
                                password.text = "";
                                newPassword.text = "";
                                confirmPassword.text = "";
                                setState(() {
                                  isPasswordValid = true;
                                  isValidate = false;
                                  isButtonEnabled = false;
                                  myFocusNode.requestFocus();
                                });
                              }
                            }
                          }
                        : null,
                    child: Text('Đổi mật khẩu'),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextButton(
                        onPressed: () {
                          // Xử lý sự kiện hủy bỏ
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Hủy',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
