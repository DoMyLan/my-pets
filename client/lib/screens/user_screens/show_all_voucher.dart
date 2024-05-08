import 'package:flutter/material.dart';
import 'package:found_adoption_application/custom_widget/voucher_item.dart';
import 'package:found_adoption_application/main.dart';

class VoucherScreen extends StatefulWidget {
  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  TextEditingController _voucherController = TextEditingController();
  Color _buttonColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    // Thêm lắng nghe sự thay đổi của _voucherController
    _voucherController.addListener(_updateButtonColor);
  }

  void _updateButtonColor() {
    setState(() {
      // Cập nhật màu nền của nút dựa trên trạng thái của _voucherController
      if (_voucherController.text.isNotEmpty) {
        _buttonColor = mainColor; // Màu chính khi có dữ liệu
      } else {
        _buttonColor = Colors.grey; // Màu xám khi không có dữ liệu
      }
    });
  }

  @override
  void dispose() {
    // Hủy lắng nghe khi Widget bị hủy
    _voucherController.removeListener(_updateButtonColor);
    _voucherController.dispose();
    super.dispose();
  }

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
                        controller: _voucherController,
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
                        // Thực hiện hành động khi nút được nhấn
                      },
                      child: Text(
                        'Áp dụng',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _buttonColor, // Sử dụng màu được cập nhật
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              Container(
                // height: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ưu đãi phí vận chuyển',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Có thể chọn 1 voucher',
                      style: TextStyle(fontSize: 14),
                    ),
                    VoucherItemSelected(
                      type: 'Shipping',
                      descriptionVoucher: 'Giảm tối đa 15k',
                    ),
                    VoucherItemSelected(
                      type: 'Shipping',
                      descriptionVoucher: 'Giảm tối đa 15k',
                    ),
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
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Có thể chọn 1 voucher',
                      style: TextStyle(fontSize: 14),
                    ),
                    VoucherItemSelected(
                      type: 'Coupon',
                      descriptionVoucher: 'Giảm tối đa 50k',
                    ),
                    VoucherItemSelected(
                      type: 'Coupon',
                      descriptionVoucher: 'Giảm tối đa 50k',
                    ),
                    VoucherItemSelected(
                      type: 'Coupon',
                      descriptionVoucher: 'Giảm tối đa 50k',
                    ),
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
