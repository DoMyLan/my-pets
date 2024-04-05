import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/userCenter.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/screens/user_screens/upload_avatar_screen.dart';
import 'package:found_adoption_application/services/user/profile_api.dart';
import 'package:found_adoption_application/utils/error.dart';
import 'package:hive/hive.dart';

class EditProfileCenterScreen extends StatefulWidget {
  const EditProfileCenterScreen({super.key});

  @override
  State<EditProfileCenterScreen> createState() =>
      _EditProfileCenterScreenState();
}

class _EditProfileCenterScreenState extends State<EditProfileCenterScreen> {
  bool isObsecurePassword = true;
  late Future<InfoCenter> centerFuture;
  TextEditingController textName = TextEditingController();
  TextEditingController textPhoneNumber = TextEditingController();
  TextEditingController textAddress = TextEditingController();

  @override
  void initState() {
    super.initState();
    centerFuture = getProfileCenter(context, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('My Profile', style: TextStyle(color: Color.fromRGBO(48, 96, 96, 1.0), fontSize: 23,),),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color.fromRGBO(48, 96, 96, 1.0),
          ),
          onPressed: () async {
            var userBox = await Hive.openBox('userBox');
            var centerBox = await Hive.openBox('centerBox');

            var currentUser = userBox.get('currentUser');
            var currentCenter = centerBox.get('currentCenter');

            var currentClient =
                currentUser != null && currentUser.role == 'USER'
                    ? currentUser
                    : currentCenter;

            if (currentClient != null) {
              if (currentClient.role == 'USER') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MenuFrameUser(
                            userId: currentClient.id,
                          )),
                );
              } else if (currentClient.role == 'CENTER') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MenuFrameCenter(
                            centerId: currentClient.id,
                          )),
                );
              }
            }
          },
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ))
        ],
      ),
      body: FutureBuilder<InfoCenter>(
          future: centerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // If the Future is still loading, show a loading indicator
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              // If there is an error fetching data, show an error message
              return const errorWidget();
            } else {
              // If data is successfully fetched, display the form
              InfoCenter center = snapshot.data!;
              return Container(
                padding: EdgeInsets.only(left: 15, top: 20, right: 15),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: ListView(
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 4, color: Colors.white),

                                  //hiệu ứng bóng đổ
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        color: Colors.black.withOpacity(0.1))
                                  ],
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(center.avatar),
                                  )),
                            ),
                            Positioned(
                                bottom: 0.0,
                                right: 0.0,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ImageUploadScreen()));
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 4, color: Colors.white),
                                        color: Theme.of(context).primaryColor),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      //Thực hiện các inputField

                      buildTextField('Name', center.name, false),
                      buildTextField("Phone Number", center.phoneNumber, false),
                      buildTextField("Email", center.email, true),
                      buildTextField("Role", center.role, true),
                      buildTextField("Address", center.address, false),

                      TextFormField(
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              textName.text = "";
                              textPhoneNumber.text = "";
                              textAddress.text = "";
                            },
                            child: Text(
                              'CANCEL',
                              style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 2,
                                  color: Colors.black),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await updateProfileCenter(
                                  context,
                                  textName.text.toString(),
                                  textPhoneNumber.text.toString(),
                                  textAddress.text.toString());
                              //update Hive
                              var centerBox = await Hive.openBox('centerBox');
                              var currentCenter =
                                  centerBox.get('currentCenter');
                              currentCenter.name =
                                  textName.text.toString() == ""
                                      ? currentCenter.name
                                      : textName.text.toString();
                              centerBox.put('currentCenter', currentCenter);

                              setState(() {
                                centerFuture = getProfileCenter(context, null);
                                textName.text = '';
                                textPhoneNumber.text = '';
                                textAddress.text = '';
                              });
                            },
                            child: Text(
                              'SAVE',
                              style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 2,
                                  color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  Widget buildTextField(String labelText, String placeholder, bool isReadOnly) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        controller: labelText == "Name"
            ? textName
            : (labelText == "Phone Number"
                ? textPhoneNumber
                : (labelText == "Address" ? textAddress : null)),
        readOnly: isReadOnly,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
      ),
    );
  }
}
