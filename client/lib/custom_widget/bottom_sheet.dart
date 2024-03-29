import "package:flutter/material.dart";
import "package:found_adoption_application/main.dart";
import "package:found_adoption_application/models/voucher_model.dart";
import "package:found_adoption_application/services/order/voucherApi.dart";
import "package:found_adoption_application/utils/getCurrentClient.dart";
import "package:found_adoption_application/utils/loading.dart";
import "package:intl/intl.dart";

class CustomModalBottomSheet extends StatefulWidget {
  const CustomModalBottomSheet({super.key});

  @override
  State<CustomModalBottomSheet> createState() => _CustomModalBottomSheetState();
}

class _CustomModalBottomSheetState extends State<CustomModalBottomSheet> {
  late DateTime start;
  late DateTime end;

  TextEditingController soluong = TextEditingController();
  TextEditingController voucherCodeController = TextEditingController();
  TextEditingController khuyenmai = TextEditingController();
  TextEditingController toida = TextEditingController();

  String selectedVoucher = 'Product';
  String selectedActionState = 'active';
  var currentClient;

  @override
  void initState() {
    super.initState();

    start = DateTime.now();
    end = DateTime.now().add(const Duration(days: 1));
    getClient();
  }

  Future<void> getClient() async {
    var temp = await getCurrentClient();
    setState(() {
      currentClient = temp;
    });
  }

  Future<DateTime?> _selectDate(
      BuildContext context, DateTime selectedDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    return pickedDate;
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: mediaQueryData.viewInsets,
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.fromLTRB(15, 4, 15, 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'TẠO VOUCHER',
                style: TextStyle(
                  color: mainColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              //INPUT VOUCHER_CODE
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mã voucher',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  TextField(
                    controller: voucherCodeController,
                    decoration: InputDecoration(
                      hintText: 'VOUCHER_CODE',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: mainColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),

              //INPUT LOẠI VOUCHER
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Loại voucher',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedVoucher,
                    decoration: InputDecoration(
                      hintText: 'Loại voucher',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedVoucher = value!;
                      });
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'Product',
                        child: Text('Thú cưng'),
                      ),
                      DropdownMenuItem(
                        value: 'Shipping',
                        child: Text('Giao hàng'),
                      ),
                      DropdownMenuItem(
                        value: 'All',
                        child: Text('Tổng đơn hàng'),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(
                height: 10,
              ),

              //KHUYẾN MÃI
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Khuyến mãi'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: khuyenmai,
                          decoration: InputDecoration(
                            hintText: '50',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade500,
                                fontStyle: FontStyle.italic),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            suffixIcon: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                '%',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tối đa'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: toida,
                          decoration: InputDecoration(
                            hintText: '50.000',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade500,
                                fontStyle: FontStyle.italic),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            suffixIcon: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'VND',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 16,
              ),

              //BẮT ĐẦU + KẾT THÚC
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Bắt đầu'),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () async {
                            final pickedDate =
                                await _selectDate(context, start);
                            if (pickedDate != null && mounted) {
                              setState(() {
                                start = pickedDate;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4.0),
                              color: Colors.grey.shade300,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('dd-MM-yyyy HH:mm').format(start),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic),
                                ),
                                const Icon(Icons.calendar_today),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Kết thúc'),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () async {
                            final pickedDate = await _selectDate(context, end);
                            if (pickedDate != null && mounted) {
                              setState(() {
                                end = pickedDate;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4.0),
                              color: Colors.grey.shade300,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('dd-MM-yyyy HH:mm').format(end),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic),
                                ),
                                const Icon(Icons.calendar_today),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: <Widget>[

              //     Text(

              //             DateFormat('dd-MM-yyyy').format(birthday!.toLocal())
              //           ,
              //         style:
              //             const TextStyle(fontSize: 15, color: Colors.black)),
              //     IconButton(
              //       icon: const Icon(Icons.calendar_today),
              //       onPressed: () {
              //         _selectDate(context);
              //       },
              //     ),
              //   ],
              // ),

              const SizedBox(
                height: 16,
              ),
              //SỐ LƯỢNG + TRẠNG THÁI HOẠT ĐỘNG
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Số lượng'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: soluong,
                          decoration: InputDecoration(
                            hintText: '30',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade500,
                                fontStyle: FontStyle.italic),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Trạng thái hoạt động'),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: selectedActionState,
                          decoration: InputDecoration(
                            hintText: 'Hoạt động',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedActionState = value!;
                            });
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 'active',
                              child: Text('Hoạt động'),
                            ),
                            DropdownMenuItem(
                              value: 'non-active',
                              child: Text('Không hoạt động'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),

              ElevatedButton(
                onPressed: () async {
                  Loading(context);
                  Voucher voucher = Voucher(
                      id: "id",
                      code: voucherCodeController.text,
                      type: selectedVoucher,
                      discount: int.parse(khuyenmai.text),
                      maxDiscount: int.parse(toida.text),
                      startDate: start,
                      endDate: end,
                      status: selectedActionState,
                      createdBy: currentClient.id,
                      quantity: int.parse(soluong.text),
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now());
                  await createVoucher(voucher);
                  Navigator.of(context).pop();
                  Navigator.pop(context, voucher);

                  setState(() {
                    voucherCodeController.clear();
                    khuyenmai.clear();
                    toida.clear();
                    soluong.clear();
                  });
                },
                style: ButtonStyle(
                  //code của Tuấn sao nó báo lỗi nên cmt lại
                  //lỗi WidgetStateProperty chưa đc define
                  // backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                  // shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: const BorderSide(color: Colors.green),
                    ),
                  ),
                ),
                child: const Text(
                  'Tạo Voucher',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ), // Văn bản của button
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    soluong.dispose();
    voucherCodeController.dispose();
    khuyenmai.dispose();
    toida.dispose();
    super.dispose();
  }
}
