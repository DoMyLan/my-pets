import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:hive/hive.dart';

class TBackHomePage extends StatelessWidget {
  const TBackHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: const Icon(
        FontAwesomeIcons.bars,
        size: 25,
        color: Color.fromRGBO(48, 96, 96, 1.0),
      ),
      onTap: () async {
        var userBox = await Hive.openBox('userBox');
        var centerBox = await Hive.openBox('centerBox');

        var currentUser = userBox.get('currentUser');
        var currentCenter = centerBox.get('currentCenter');

        var currentClient = currentUser != null && currentUser.role == 'USER'
            ? currentUser
            : currentCenter;

        if (currentClient != null) {
          if (currentClient.role == 'USER') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MenuFrameUser(
                  userId: currentClient.id,
                ),
              ),
            );
          } else if (currentClient.role == 'CENTER') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MenuFrameCenter(
                  centerId: currentClient.id,
                ),
              ),
            );
          }
        }
      },
    );
  }
}
