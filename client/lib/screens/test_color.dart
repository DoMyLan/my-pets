import 'package:flutter/material.dart';

class PetInfoForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4, // Add elevation for shadow effect
              margin: EdgeInsets.all(0), // No margin
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      Icons.assignment,
                      'Hướng dẫn nuôi:',
                      'Nhập hướng dẫn nuôi',
                    ),
                    _buildInfoRow(
                      Icons.info,
                      'Lưu ý:',
                      'Nhập lưu ý',
                    ),
                    _buildInfoRow(
                      Icons.favorite,
                      'Sở thích:',
                      'Nhập sở thích',
                    ),
                    _buildInfoRow(
                      Icons.local_hospital,
                      'Tiêm chủng:',
                      'Nhập tiêm chủng',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.blue),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          TextField(
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PetInfoForm(),
  ));
}
