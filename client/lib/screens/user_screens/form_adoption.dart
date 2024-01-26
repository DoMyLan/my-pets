import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormAdopt extends StatefulWidget {
  const FormAdopt({super.key});

  @override
  State<FormAdopt> createState() => _FormAdoptState();
}

class _FormAdoptState extends State<FormAdopt> {
  DateTime? interviewDate;
  DateTime? selectedAdoptionDate;
  bool acceptRequire = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: interviewDate == null ? DateTime.now() : interviewDate!,
      firstDate: DateTime.now(), // Only allow dates after today
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != interviewDate) {
      setState(() {
        interviewDate = picked;
        selectedAdoptionDate = picked.add(const Duration(days: 5));
      });
    }
  }

  Future<void> _selectAdoptionDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedAdoptionDate == null
          ? interviewDate!.add(const Duration(days: 5))
          : selectedAdoptionDate!,
      firstDate: interviewDate!.add(
          const Duration(days: 5)), // Only allow dates after the interview date
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedAdoptionDate) {
      setState(() {
        selectedAdoptionDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          padding:
              const EdgeInsets.only(left: 30, top: 0, right: 30, bottom: 0),
          constraints: const BoxConstraints.expand(),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Container(
                    width: 70,
                    height: 70,
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xffd8d8d8)),
                    child: const FlutterLogo(size: 100)),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Text("Bạn muốn nhận nuôi chúng chứ?",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: TextField(
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Tên của bạn",
                    labelStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: TextField(
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: TextField(
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Số điện thoại",
                    labelStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: TextField(
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Địa chỉ",
                    labelStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text("Ngày phỏng vấn: ",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold)),
                  Text(
                      interviewDate != null
                          ? DateFormat('dd-MM-yyyy')
                              .format(interviewDate!.toLocal())
                          : 'Chưa chọn ngày',
                      style:
                          const TextStyle(fontSize: 15, color: Colors.black)),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      _selectDate(context);
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text("Ngày nhận dự kiến: ",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold)),
                    Text(
                        selectedAdoptionDate != null
                            ? DateFormat('dd-MM-yyyy')
                                .format(selectedAdoptionDate!.toLocal())
                            : 'Chưa chọn ngày',
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black)),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectAdoptionDate(context);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: CheckboxListTile(
                  title: const Text(
                      "Bạn có chấp nhận gửi hình ảnh hoặc video hàng tuần cho chúng tôi không?",
                      textAlign: TextAlign.justify),
                  value: acceptRequire,
                  onChanged: (bool? value) {
                    setState(() {
                      acceptRequire = value!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity
                      .leading, //  places the checkbox at the start (leading/trailing)
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    // Add your send data function here
                    // print('Button has been pressed');
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Gửi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
