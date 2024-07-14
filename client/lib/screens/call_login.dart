import 'package:flutter/material.dart';
import 'package:found_adoption_application/screens/login_screen.dart';

class CallLogin extends StatelessWidget {
  const CallLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Vui lòng đăng nhập'),
            SizedBox(height: 20), // Khoảng cách giữa text và nút
            ElevatedButton(
              onPressed: () {
                // Điều hướng đến màn hình đăng nhập
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Đăng Nhập'),
            ),
          ],
        ),
      ),
    );
  }
}
