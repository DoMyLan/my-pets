import 'package:flutter/material.dart';
import 'package:found_adoption_application/services/center/petApi.dart';
import 'package:found_adoption_application/utils/loading.dart';
import 'package:intl/intl.dart';

class PriceSale extends StatefulWidget {
  final String petId;
  final int priceSale;
  final DateTime? dateStartSale;
  final DateTime? dateEndSale;
  final int petPrice;
  const PriceSale({
    super.key,
    required this.petPrice,
    required this.petId,
    required this.priceSale,
    this.dateStartSale,
    this.dateEndSale,
  });

  @override
  State<PriceSale> createState() => _PriceSaleState();
}

class _PriceSaleState extends State<PriceSale> {
  int _priceReduce = 0;
  DateTime? dateStartReduce = null;
  DateTime? dateEndReduce = null;
  late String errorPriceReduce = "";
  late String errorDateStartReduce = "";
  late String errorDateEndReduce = "";

  @override
  void initState() {
    super.initState();
    _priceReduce = widget.priceSale;
    dateStartReduce = widget.dateStartSale;
    dateEndReduce = widget.dateEndSale;
  }

  Future<DateTime?> _selectDateAndTime(BuildContext context) async {
    // Chọn ngày
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Chỉ cho phép chọn từ ngày hiện tại trở đi
      lastDate: DateTime(3000),
    );

    if (pickedDate != null) {
      // Chọn giờ sau khi đã chọn ngày
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Kết hợp ngày và giờ đã chọn thành một DateTime
        return DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }
    return null; // Trả về null nếu người dùng hủy bất kỳ lựa chọn nào
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Giảm giá",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (text) {
              errorPriceReduce = "";
              _priceReduce = 0;
              //kiểm tra text phải là số
              if (text.isNotEmpty) {
                if (!RegExp(r'^[0-9]*$').hasMatch(text)) {
                  setState(() {
                    errorPriceReduce = "Giá giảm phải là số nguyên!";
                  });
                } else if (int.parse(text) > widget.petPrice) {
                  setState(() {
                    errorPriceReduce = 'Giá giảm không được lớn hơn giá gốc!';
                  });
                } else {
                  setState(() {
                    _priceReduce = int.parse(text);
                  });
                }
              }
            },
            decoration: InputDecoration(
              labelText: 'Nhập giá giảm',
              border: const OutlineInputBorder(),
              errorText: errorPriceReduce != "" ? errorPriceReduce : null,
              suffix: const Text('VNĐ', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            keyboardType: TextInputType.datetime,
            controller: TextEditingController(
                text: dateStartReduce != null
                    ? DateFormat('dd-MM-yyyy HH:mm')
                        .format(dateStartReduce!.toLocal())
                    : ''),
            onChanged: (text) {
              errorDateStartReduce = "";
            },
            decoration: InputDecoration(
              labelText: 'Ngày bắt đầu giảm giá',
              border: const OutlineInputBorder(),
              errorText:
                  errorDateStartReduce != "" ? errorDateStartReduce : null,
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  DateTime? a = await _selectDateAndTime(context);
                  setState(() {
                    dateStartReduce = a;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            keyboardType: TextInputType.datetime,
            controller: TextEditingController(
                text: dateEndReduce != null
                    ? DateFormat('dd-MM-yyyy HH:mm').format(dateEndReduce!.toLocal())
                    : ''),
            onChanged: (text) {
              errorDateEndReduce = "";
            },
            decoration: InputDecoration(
              labelText: 'Ngày kết thúc giảm giá',
              border: const OutlineInputBorder(),
              errorText: errorDateEndReduce != "" ? errorDateEndReduce : null,
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  DateTime? a = await _selectDateAndTime(context);
                  setState(() {
                    dateEndReduce = a;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                focusNode: FocusNode(),
                onPressed: () async {
                  if (_priceReduce == 0) {
                    setState(() {
                      errorPriceReduce = "Vui lòng nhập giá giảm!";
                    });
                  } else if (dateStartReduce == null) {
                    setState(() {
                      errorDateStartReduce = "Vui lòng chọn ngày bắt đầu!";
                    });
                  } else if (dateEndReduce == null) {
                    setState(() {
                      errorDateEndReduce = "Vui lòng chọn ngày kết thúc!";
                    });
                  } else {
                    Loading(context);
                    await salePet(widget.petId, _priceReduce, dateStartReduce,
                        dateEndReduce);
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }
                },
                child: const Text('Lưu'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Loading(context);
                  await salePet(widget.petId, 0, null, null);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
                child: const Text('Hủy giảm giá'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
