import 'dart:io';
import 'package:flutter/material.dart';
import 'package:found_adoption_application/screens/pet_center_screens/edit_profile_center.dart';
import 'package:found_adoption_application/services/image/change_avatar_api.dart';
import 'package:found_adoption_application/utils/loading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import 'package:found_adoption_application/screens/user_screens/edit_profile_screen.dart';

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  PickedFile? _pickedImage;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    PickedFile? pickedImage =
        await _picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Change Avatar',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: Theme.of(context).primaryColor),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(width: 4, color: Colors.white),
                  shape: BoxShape.circle,
                  image: _pickedImage != null
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(File(_pickedImage!.path))
                              as ImageProvider<Object>,
                        )
                      : null,
                ),
                child: _pickedImage == null
                    ? Icon(
                        Icons.add_a_photo,
                        size: 40,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            SizedBox(height: 20),
            _pickedImage != null
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () async {
                      Loading(context);
                      var url = await changeAvatar(context, _pickedImage);
                      Navigator.pop(context);

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
                          currentUser.avatar = url.toString();
                          userBox.put("currentUser", currentUser);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfileScreen()),
                          );
                        } else if (currentClient.role == 'CENTER') {
                          currentCenter.avatar = url.toString();
                          centerBox.put("currentCenter", currentCenter);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditProfileCenterScreen()),
                          );
                        }
                      }
                    },
                    child: Text(
                      'Change Avatar',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
