import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:found_adoption_application/screens/pet_center_screens/test_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/hive/current_location.dart';
import 'package:found_adoption_application/models/order.dart';


import 'package:found_adoption_application/screens/login_screen.dart';

import 'package:found_adoption_application/screens/welcome_screen.dart';
import 'package:found_adoption_application/services/auth_api.dart';
import 'package:found_adoption_application/services/order/orderApi.dart';

import 'package:found_adoption_application/utils/messageNotifi.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:found_adoption_application/models/hive/current_center.dart';
import 'package:found_adoption_application/models/hive/current_user.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:hive_flutter/hive_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(LocationAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(CenterAdapter());


  HttpOverrides.global = MyHttpOverrides();
 
  Timer.periodic(Duration(seconds: 30), (timer) async {
    await checkForChanges();
    print("abc");
  });

  

  runApp(
    Directionality(
      textDirection: TextDirection
          .ltr, // Change this to TextDirection.rtl for RTL languages
      child: MyApp(),
    ),
  );
}

Future<void> checkForChanges() async {
  List<Order> newOrders = await getOrdersBySeller('PENDING');
  int oldOrders = await getOrdersFromLocal();


  print("newOrders length: ${newOrders.length}");
  print("oldOrders length: ${oldOrders}");
  if (newOrders.length > oldOrders) {
    int num = newOrders.length - oldOrders;
    await saveOrdersToLocal(num, 'numNotify');
    // Nếu có thay đổi, cập nhật previousOrder và lưu trữ mới
    oldOrders = newOrders.length;

    notify();
  }
  await saveOrdersToLocal(newOrders.length, 'countOrders');
}


Future<void> saveOrdersToLocal(int count, String namePref) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt(namePref, count);
}

Future<int> getOrdersFromLocal() async {
 
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int orders = prefs.getInt('countOrders') ?? 0;

  return orders;
}


void notify() async{
  // Hàm để thông báo có sự thay đổi
   final NotificationHandler notificationHandler = NotificationHandler();
  await notificationHandler.showNotification();
  print('Orders have changed!');
}


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Color mainColor = const Color.fromRGBO(48, 96, 96, 1.0);
Color startingColor = const Color.fromRGBO(70, 112, 112, 1.0);

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: mainColor,
//       ),
//       home: ReviewProfileScreen(),
//     );
//   }
// }

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool> hasValidRefreshToken = checkRefreshToken();

  late io.Socket socket;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  var serverUrl = 'http://socket-found-adoption-dangvantuan.koyeb.app';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      // future: hasValidRefreshToken,
      future: Future.delayed(Duration(seconds: 4), () => hasValidRefreshToken),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final refreshTokenIsValid = snapshot.data;
          if (refreshTokenIsValid != false) {
            //CHECK ROLE
            return FutureBuilder<Box>(
              future: Hive.openBox('userBox'),
              builder: (context, userBoxSnapshot) {
                if (userBoxSnapshot.connectionState == ConnectionState.done) {
                  var userBox = userBoxSnapshot.data;
                  return FutureBuilder<Box>(
                    future: Hive.openBox('centerBox'),
                    builder: (context, centerBoxSnapshot) {
                      if (centerBoxSnapshot.connectionState ==
                          ConnectionState.done) {
                        var centerBox = centerBoxSnapshot.data;
                        var currentUser = userBox!.get('currentUser');
                        var currentCenter = centerBox!.get('currentCenter');

                        var currentClient =
                            currentUser != null && currentUser.role == 'USER'
                                ? currentUser
                                : currentCenter;

                        Map<String, dynamic> decodedToken =
                            Jwt.parseJwt(currentClient.refreshToken);
                        DateTime expirationTime =
                            DateTime.fromMillisecondsSinceEpoch(
                                decodedToken['exp'] * 1000);
                        DateTime now = DateTime.now();

                        bool isTokenExpired = now.isAfter(expirationTime);
                        if (!isTokenExpired) {
                          refreshAccessToken();
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => LoginScreen())));
                          notification(
                              "The login session has expired, please log in again!",
                              false);
                        }

                        if (currentClient != null) {
                          //connect socket server
                          socket = io.io(serverUrl, <String, dynamic>{
                            'transports': ['websocket'],
                            'autoConnect': true,
                          });

                          if (currentClient.role == 'USER') {
                            socket.emit(
                                'addNewUser', {'userId': currentClient.id});
                            return MaterialApp(
                              title: 'My Pets',
                              debugShowCheckedModeBanner: false,
                              theme: ThemeData(
                                primaryColor: mainColor,
                              ),
                              home: MenuFrameUser(
                                userId: currentClient.id,
                              ),
                            );
                          } else if (currentClient.role == 'CENTER') {
                            socket.emit(
                                'addNewUser', {'userId': currentClient.id});
                            return MaterialApp(
                              title: 'My Pets',
                              debugShowCheckedModeBanner: false,
                              theme: ThemeData(
                                primaryColor: mainColor,
                              ),
                              home: MenuFrameCenter(centerId: currentClient.id),
                            );
                          }
                        }
                      }
                      return const CircularProgressIndicator();
                    },
                  );
                }
                return const CircularProgressIndicator();
              },
            );
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: mainColor,
              ),
              home: LoginScreen(),
            );
          }
        }
        return WelcomeScreen();
      },
    );
  }
}

Future<bool> checkRefreshToken() async {
  try {
    var userBox = await Hive.openBox('userBox');
    var currentUser = userBox.get('currentUser');

    var centerBox = await Hive.openBox('centerBox');
    var currentCenter = centerBox.get('currentCenter');

    var currentClient = currentUser != null && currentUser.role == 'USER'
        ? currentUser
        : currentCenter;

    var clientBox =
        currentUser != null && currentUser.role == 'USER' ? userBox : centerBox;

    // var name = currentUser != null && currentUser.role == 'USER'
    //     ? currentUser!.firstName
    //     : currentCenter!.name;

    currentUser != null && currentUser.role == 'USER'
        ? currentUser!.firstName
        : currentCenter != null
            ? currentCenter.name
            : 'Unknown';

    final refreshTokenTimestamp = clientBox.get('refreshTokenTimestamp');
    const refreshTokenValidityDays = 7;
    final DateTime now = DateTime.now();

    if (currentClient != null) {
      final expirationTime = refreshTokenTimestamp.add(
        Duration(days: refreshTokenValidityDays),
      );

      if (now.isBefore(expirationTime)) {
        return true;
      }
    }
    return false;
  } catch (e) {
    print(e);
    return false;
  }
}
