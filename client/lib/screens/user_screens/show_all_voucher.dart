import 'package:flutter/material.dart';
import 'package:found_adoption_application/custom_widget/voucher_item.dart';
import 'package:found_adoption_application/main.dart';

// Model cho voucher
class Voucher {
  final String id;
  final String type;
  final String code;
  final String description;

  Voucher(
      {required this.id,
      required this.type,
      required this.code,
      required this.description});
}

// Widget hiển thị màn hình voucher
class VoucherScreen extends StatelessWidget {
  // Danh sách voucher
  final List<Voucher> vouchers = [
    Voucher(
        id: '1',
        type: 'Ưu đãi phí vận chuyển',
        code: 'SHIPFREE',
        description: 'Miễn phí vận chuyển cho đơn hàng trên 50'),
    Voucher(
        id: '2',
        type: 'Mã giảm giá',
        code: 'SALE20',
        description: 'Giảm giá 20% cho đơn hàng đầu tiên'),
    // Thêm các voucher khác vào đây
  ];

  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Theme.of(context).primaryColor,
        ),
        title: Text('Danh sách voucher'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Nhập mã voucher
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50, 
                      child: TextField(
                     
                        decoration: InputDecoration(
                          hintText: 'Nhập mã voucher',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), 
                  Container(
                    height: 50, 
                    child: ElevatedButton(
                      onPressed: () {
                        
                      },
                      child: Text(
                        'Áp dụng',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
        
              Container(
                // height: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ưu đãi phí vận chuyển',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Có thể chọn 1 voucher',
                      style: TextStyle(fontSize: 14),
                    ),
                    VoucherItemSelected(type: 'Shipping',),
                    VoucherItemSelected(type: 'Shipping',),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Divider(
                color: Colors.grey.shade300,
                thickness: 1,
                height: 4,
              ),
              SizedBox(height: 16),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mã giảm giá',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Có thể chọn 1 voucher',
                      style: TextStyle(fontSize: 14),
                    ),
                    VoucherItemSelected(type: 'Coupon',),
                    VoucherItemSelected(type: 'Coupon',),
                    VoucherItemSelected(type: 'Coupon',),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: VoucherScreen(),
  ));
}
