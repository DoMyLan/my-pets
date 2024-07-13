import 'package:flutter/material.dart';
import 'package:found_adoption_application/screens/place_auto_complete.dart';
import 'package:found_adoption_application/services/center/center_form.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RegistrationCenterForm extends StatefulWidget {
  const RegistrationCenterForm({super.key});

  @override
  State<RegistrationCenterForm> createState() => _RegistrationCenterFormState();
}

class _RegistrationCenterFormState extends State<RegistrationCenterForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(48, 96, 96, 1.0),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(
                  context); // Đặt hàm Navigator.pop(context) trong hàm lambda
            },
          ),
          title: const Text("Đăng ký trung tâm"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(
                    Icons.home,
                    color: Color.fromRGBO(48, 96, 96, 1.0),
                  ),
                  hintText: "Tên trung tâm",
                  labelText: 'Tên trung tâm',
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              //PHONE NUMBER
              TextFormField(
                controller: phoneNumberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(
                      Icons.call,
                      color: Color.fromRGBO(48, 96, 96, 1.0),
                    ),
                    hintText: 'Số điện thoại',
                    labelText: 'Số điện thoại',
                    prefixText: '+84 '),
              ),
              const SizedBox(
                height: 24,
              ),

              

              //ĐỊA CHỈ
              placesAutoCompleteTextField(addressController),

              const SizedBox(
                height: 70,
              ),

              TextFormField(
                controller: aboutMeController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Nói về trung tâm của bạn',
                    helperText: 'Nhập thông tin về trung tâm của bạn',
                    labelText: 'Giới thiệu'),
                maxLines: 4,
              ),

              const SizedBox(
                height: 40,
              ),

              //Button
              MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: () {},
                color: const Color.fromRGBO(48, 96, 96, 1.0),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: GestureDetector(
                  onTap: () async {
                    LatLng location =await convertAddressToLatLng(addressController.text.toString());
                    await centerform(
                        context,
                        nameController.text.toString(),
                        phoneNumberController.text.toString(),
                        addressController.text.toString(),
                        aboutMeController.text.toString(),
                        location,
                        );
                  },
                  child: const Text(
                    "Tiếp theo",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
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

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
