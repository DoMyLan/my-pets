import 'package:flutter/material.dart';
import 'package:found_adoption_application/custom_widget/voucher_item.dart';
import 'package:found_adoption_application/main.dart';
import 'package:found_adoption_application/models/voucher_model.dart';
import 'package:found_adoption_application/services/order/voucherApi.dart';

// Model cho voucher
// class Voucher {
//   final String id;
//   final String type;
//   final String code;
//   final String description;

//   Voucher(
//       {required this.id,
//       required this.type,
//       required this.code,
//       required this.description});
// }

// Widget hiển thị màn hình voucher
// ignore: must_be_immutable
class VoucherScreen extends StatefulWidget {
  final String centerId;
  final String? selectedVoucherCode;
  const VoucherScreen(
      {super.key, required this.centerId, this.selectedVoucherCode});

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  Future<List<Voucher>>? voucherPFuture;
  Future<List<Voucher>>? voucherSFuture;
  Future<List<Voucher>>? voucherTFuture;

  String? selectedVoucherCode;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    voucherPFuture = getVoucherCenter(widget.centerId, "Product");
    voucherSFuture = getVoucherCenter(widget.centerId, "Shipping");
    voucherTFuture = getVoucherCenter(widget.centerId, "All");
    selectedVoucherCode = widget.selectedVoucherCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Theme.of(context).primaryColor,
        ),
        title: const Text('Danh sách voucher'),
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
                  const Expanded(
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Nhập mã voucher',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(selectedVoucherCode);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: const Text(
                        'Áp dụng',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const Text(
                'Chỉ có thể chọn 1 voucher trong tất cả các loại voucher',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(
                height: 20,
              ),

              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text(
                  'Ưu đãi phí vận chuyển',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                FutureBuilder(
                  future: voucherSFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('Error'),
                      );
                    } else {
                      List<Voucher> voucherS = snapshot.data as List<Voucher>;
                      if (voucherS.isEmpty) {
                        return const Center(
                            child: Text('Không có voucher nào'));
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: voucherS.length,
                          itemBuilder: (context, index) {
                            if (voucherS[index].code == selectedVoucherCode) {
                              isSelected = true;
                            }

                            return VoucherItemSelected(
                              voucher: voucherS[index],
                              onChanged: (isSelected) {
                                setState(() {
                                  if (isSelected) {
                                    selectedVoucherCode = voucherS[index].code;
                                  } else {
                                    selectedVoucherCode = null;
                                  }
                                });
                              },
                            );
                          },
                        );
                      }
                    }
                  },
                )
              ]),
              const SizedBox(height: 10),
              Divider(
                color: Colors.grey.shade300,
                thickness: 1,
                height: 4,
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mã giảm giá',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  FutureBuilder(
                    future: voucherPFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Error'),
                        );
                      } else {
                        List<Voucher> voucherS = snapshot.data as List<Voucher>;
                        if (voucherS.isEmpty) {
                          return const Center(
                              child: Text('Không có voucher nào'));
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: voucherS.length,
                            itemBuilder: (context, index) {
                              if (voucherS[index].code == selectedVoucherCode) {
                                isSelected = true;
                              }
                              return VoucherItemSelected(
                                voucher: voucherS[index],
                                onChanged: (isSelected) {
                                  setState(() {
                                    if (isSelected) {
                                      selectedVoucherCode =
                                          voucherS[index].code;
                                    } else {
                                      selectedVoucherCode = null;
                                    }
                                  });
                                },
                              );
                            },
                          );
                        }
                      }
                    },
                  )
                ],
              ),
              const SizedBox(height: 10),
              Divider(
                color: Colors.grey.shade300,
                thickness: 1,
                height: 4,
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Giảm giá tổng đơn hàng',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  FutureBuilder(
                    future: voucherTFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Error'),
                        );
                      } else {
                        List<Voucher> voucherS = snapshot.data as List<Voucher>;
                        if (voucherS.isEmpty) {
                          return const Center(
                              child: Text('Không có voucher nào'));
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: voucherS.length,
                            itemBuilder: (context, index) {
                              if (voucherS[index].code == selectedVoucherCode) {
                                isSelected = true;
                              }
                              return VoucherItemSelected(
                                voucher: voucherS[index],
                                onChanged: (isSelected) {
                                  setState(() {
                                    if (isSelected) {
                                      selectedVoucherCode =
                                          voucherS[index].code;
                                    } else {
                                      selectedVoucherCode = null;
                                    }
                                  });
                                },
                              );
                            },
                          );
                        }
                      }
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: VoucherScreen(),
//   ));
// }
