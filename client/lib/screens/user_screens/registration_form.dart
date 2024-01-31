import 'package:flutter/material.dart';
import 'package:found_adoption_application/screens/place_auto_complete.dart';
import 'package:found_adoption_application/services/user/user_form_api.dart';

class RegistrationForm extends StatefulWidget {
  final String accountId;
  const RegistrationForm({super.key, required this.accountId});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  bool selectedRadio = true;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController auboutMeController = TextEditingController();

  setSelectedRadio(bool val) {
    setState(() {
      selectedRadio = val;
    });
  }

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
          title: Text("Registration User's Form"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    //FIRST NAME
                    child: TextFormField(
                      controller: firstNameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: true,
                        icon: Icon(
                          Icons.person,
                          color: const Color.fromRGBO(48, 96, 96, 1.0),
                        ),
                        hintText: 'First Name',
                        labelText: 'First Name',
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Khoảng cách giữa hai trường

                  //LAST NAME
                  Expanded(
                    child: TextFormField(
                      controller: lastNameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: true,
                        hintText: 'Last Name',
                        labelText: 'Last Name',
                      ),
                    ),
                  ),
                ],
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
              // TextFormField(
              //   controller: addressController,
              //   keyboardType: TextInputType.streetAddress,
              //   decoration: InputDecoration(
              //       border: UnderlineInputBorder(),
              //       filled: true,
              //       icon: Icon(
              //         Icons.location_on,
              //         color: const Color.fromRGBO(48, 96, 96, 1.0),
              //       ),
              //       hintText: 'Your Address',
              //       labelText: 'Address'),
              // ),

              //ĐỊA CHỈ
              placesAutoCompleteTextField(addressController),

              SizedBox(
                height: 24,
              ),

              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'Experiences: ',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
              ),

              //Radion button Experience
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                      value: true,
                      groupValue: selectedRadio,
                      onChanged: (val) {
                        setSelectedRadio(val!);
                      }),
                  Text('Yes'),
                  SizedBox(
                    width: 50,
                  ),
                  Radio(
                      value: false,
                      groupValue: selectedRadio,
                      onChanged: (val) {
                        setSelectedRadio(val!);
                      }),
                  Text('No'),
                ],
              ),

              TextFormField(
                controller: auboutMeController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Tell us about yourself',
                    helperText: 'Keep it short, this is just demo',
                    labelText: 'Life Story'),
                maxLines: 4,
              ),

              SizedBox(
                height: 30,
              ),

              //Button
              MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: () async {
                  await userform(
                      context,
                      widget.accountId,
                      firstNameController.text.toString(),
                      lastNameController.text.toString(),
                      phoneNumberController.text.toString(),
                      addressController.text.toString(),
                      selectedRadio,
                      auboutMeController.text.toString());

                      // LatLng a =await convertAddressToLatLng(addressController.text.toString());

                      // print('Tọa độ Address mới nhập: $a');
                },
                color: const Color.fromRGBO(48, 96, 96, 1.0),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: GestureDetector(
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
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
