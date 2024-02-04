import 'package:flutter/material.dart';
import 'package:found_adoption_application/screens/place_auto_complete.dart';
import 'package:found_adoption_application/services/center/center_form.dart';

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
          backgroundColor: Color.fromRGBO(48, 96, 96, 1.0),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(
                  context); // Đặt hàm Navigator.pop(context) trong hàm lambda
            },
          ),
          title: Text("Registration Center's Form"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10, 40, 10, 0),
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(
                    Icons.home,
                    color: const Color.fromRGBO(48, 96, 96, 1.0),
                  ),
                  hintText: "Center's Name",
                  labelText: 'Name of Center',
                ),
              ),

              SizedBox(
                height: 24,
              ),

              //PHONE NUMBER
              TextFormField(
                controller: phoneNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(
                      Icons.call,
                      color: const Color.fromRGBO(48, 96, 96, 1.0),
                    ),
                    hintText: 'Where can we reach you',
                    labelText: 'Phone Number',
                    prefixText: '+84 '),
              ),
              SizedBox(
                height: 24,
              ),

              

              //ĐỊA CHỈ
              placesAutoCompleteTextField(addressController),

              SizedBox(
                height: 70,
              ),

              TextFormField(
                controller: aboutMeController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Tell us about yourself',
                    helperText: 'Keep it short, this is just demo',
                    labelText: 'Life Story'),
                maxLines: 4,
              ),

              SizedBox(
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
                    await centerform(
                        context,
                        nameController.text.toString(),
                        phoneNumberController.text.toString(),
                        addressController.text.toString(),
                        aboutMeController.text.toString());
                  },
                  child: Text(
                    "Continue",
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
