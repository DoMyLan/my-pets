import 'dart:convert';
import 'package:found_adoption_application/utils/consts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class PaymentConversion {
  static const String currencyConversionApiUrl =
      'https://api.fastforex.io/convert?from=VND&to=USD&amount=1&api_key=$apiKeyExchangeRate';

  static Future<double> getExchangeRate() async {
    try {
      final response = await http.get(Uri.parse(currencyConversionApiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['result']['rate'];
      } else {
        throw Exception('Failed to load exchange rates');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<double> convertVNDtoUSD(double amountInVND) async {
    try {
      double exchangeRate = await getExchangeRate();
      return amountInVND * exchangeRate;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

class CurrencyConversionTestWidget extends StatefulWidget {
  @override
  _CurrencyConversionTestWidgetState createState() =>
      _CurrencyConversionTestWidgetState();
}

class _CurrencyConversionTestWidgetState
    extends State<CurrencyConversionTestWidget> {
  TextEditingController _vndController = TextEditingController();
  double _convertedAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Conversion Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _vndController,
              decoration: InputDecoration(
                labelText: 'Amount in VND',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  double amountInVND =
                      double.parse(_vndController.text.isEmpty
                          ? '0'
                          : _vndController.text);
                  PaymentConversion.convertVNDtoUSD(amountInVND)
                      .then((convertedAmount) {
                    setState(() {
                      _convertedAmount = convertedAmount;
                    });
                  }).catchError((error) {
                    print('Error: $error');
                  });
                });
              },
              child: Text('Convert to USD'),
            ),
            SizedBox(height: 20),
            Text(
              'Converted Amount in USD: $_convertedAmount',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CurrencyConversionTestWidget(),
  ));
}
