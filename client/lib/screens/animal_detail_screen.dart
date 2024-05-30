import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/models/pet.dart';
import 'package:found_adoption_application/screens/payment_screen.dart';
import 'package:found_adoption_application/screens/pet_center_screens/edit_pet_screen.dart';
import 'package:found_adoption_application/screens/pet_center_screens/profile_center.dart';
import 'package:found_adoption_application/screens/review_rating_screen.dart';
import 'package:found_adoption_application/services/center/petApi.dart';
import 'package:found_adoption_application/utils/error.dart';
import 'package:found_adoption_application/utils/loading.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';
import 'package:intl/intl.dart';

class AnimalDetailScreen extends StatefulWidget {
  final String petId;
  final dynamic currentId;

  const AnimalDetailScreen(
      {super.key, required this.petId, required this.currentId});

  @override
  State<AnimalDetailScreen> createState() => _AnimalDetailScreenState();
}

class _AnimalDetailScreenState extends State<AnimalDetailScreen> {
  int currentIndex = 0;
  dynamic currentClient;
  // bool _isExpanded = false;
  int maxlines = 3;
  late bool isFavorite = false;
  Future<Pet>? petFuture;

  final CarouselController carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    currentClient = widget.currentId;
    petFuture = getPet(widget.petId);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
        future: petFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const errorWidget();
          } else {
            Pet pet = snapshot.data as Pet;

            for (var element in pet.favorites!) {
              if (element == currentClient.id) {
                isFavorite = true;
              }
            }

            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Stack(children: [
                        Container(
                          child: pet.images.length == 1
                              ? Hero(
                                  tag: pet.namePet,
                                  child: Image(
                                    height: screenHeight * 0.4,
                                    width: double.infinity,
                                    image: NetworkImage(pet.images.first),
                                    fit: BoxFit.cover, //vấn đề ở đây nè nha
                                  ),
                                )
                              : _slider(pet.images),
                        ),
                        Container(
                          height: screenHeight * 0.4,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.1),
                                Colors.black.withOpacity(0.6)
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            height: screenHeight * 0.38,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      pet.namePet,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(" - ${pet.breed}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      pet.reducePrice != 0
                                          ? (int.parse(pet.price) -
                                                      pet.reducePrice) >
                                                  0
                                              ? "${int.parse(pet.price) - pet.reducePrice}đ   "
                                              : 'Miễn phí   '
                                          : pet.price,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    pet.reducePrice > 0
                                        ? Text("${pet.price}đ",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                decorationThickness: 2.0,
                                                decorationColor: Colors.white))
                                        : const SizedBox()
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ]),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            currentClient.role == 'CENTER'
                                ? PopupMenuButton<String>(
                                    color: Colors.white,
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    onSelected: (String choice) {
                                      // Handle menu item selection
                                      if (choice == 'edit') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditPetScreen(pet: pet),
                                          ),
                                        );
                                      } else if (choice == 'delete') {
                                        _showDeleteConfirmationDialog(pet.id);
                                      }
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<String>>[
                                      PopupMenuItem<String>(
                                        value: 'edit',
                                        child: Text(
                                          'Chỉnh sửa',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Text(
                                          'Xóa',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),

                  //Nửa giao diện ở dưới(bắt đầu chứa content của user)
                  //Role truy cập hiện tại là trung tâm

                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Container(
                      height: MediaQuery.sizeOf(context).height * 0.45,
                      color: Colors.white,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 30.0,
                                    backgroundImage:
                                        NetworkImage(pet.centerId!.avatar),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfileCenterPage(
                                                    centerId: pet.centerId!.id,
                                                    petId: pet.id,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              pet.centerId!.name,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              softWrap: true,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            DateFormat.yMMMMd()
                                                .add_Hms()
                                                .format(pet.createdAt!),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              //Đã mua + đánh giá ở screen Review
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //Số lượng thú cưng đang đăng bán
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.done,
                                        color: Colors.green,
                                        weight: 20,
                                        fill: 0.8,
                                      ),
                                      Text(
                                        ' Đã mua',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    width: 20,
                                  ),

                                  //đánh giá sao
                                  RichText(
                                    text: const TextSpan(
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: '4.9',
                                          style:
                                              TextStyle(color: Colors.orange),
                                        ),
                                        TextSpan(text: ' Đánh giá'),
                                      ],
                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      // Chuyển đến Trang ReviewProfileScreen
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ReviewProfileScreen(
                                                      centerId:
                                                          pet.centerId!.id)));
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.solidHandPointRight,
                                          size: 16,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        // Khoảng cách giữa icon và text
                                        Text(
                                          'Xem đánh giá',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 2,
                              ),

                              Divider(
                                color: Colors.grey.shade200,
                                thickness: 10,
                                height: 13,
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Chi tiết thú cưng',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    style: ButtonStyle(
                                      padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                        const EdgeInsets.all(
                                            0), // Đây là giá trị padding bạn muốn thiết lập
                                      ),
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          //widget modelbottomsheet
                                          return CustomModalBottomSheet(
                                              context, pet);
                                        },
                                      );
                                    },
                                    child: const Row(
                                      children: [
                                        Text(
                                          'Tên, Giống, Tuổi,...',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Color.fromARGB(
                                                  255, 90, 90, 90)),
                                        ),
                                        Icon(
                                          Icons.navigate_next,
                                          size: 20,
                                          color:
                                              Color.fromARGB(255, 90, 90, 90),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),

                              Divider(
                                color: Colors.grey.shade200,
                                height: 10, // Chiều cao của đường gạch ngang
                                thickness: 1,
                              ),

                              const Text(
                                'Mô tả thú cưng',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              //Pet information Detail
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildInfoRow(
                                        Icons.assignment,
                                        'Hướng dẫn nuôi:',
                                        'Nhập hướng dẫn nuôi',
                                        pet.instruction,
                                      ),
                                      _buildInfoRow(
                                        Icons.info,
                                        'Lưu ý:',
                                        'Nhập lưu ý',
                                        pet.attention,
                                      ),
                                      _buildInfoRow(
                                        Icons.favorite,
                                        'Sở thích:',
                                        'Nhập sở thích',
                                        pet.hobbies,
                                      ),
                                      _buildInfoRow(
                                        Icons.local_hospital,
                                        'Tiêm chủng:',
                                        'Nhập tiêm chủng',
                                        pet.inoculation,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),


                  Spacer(),
                  if (currentClient.role == "USER" &&
                      pet.statusPaid == 'NOTHING')
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        height: 50,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    isFavorite = !isFavorite;
                                  });
                                  Loading(context);
                                  await favoritePet(pet.id);
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop();
                                },
                                child: Material(
                                  borderRadius: BorderRadius.circular(20),
                                  elevation: 4,
                                  color: Theme.of(context).primaryColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Icon(
                                      isFavorite
                                          ? FontAwesomeIcons.solidHeart
                                          : FontAwesomeIcons.heart,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                 

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PaymentScreen(
                                              pet: pet,
                                              currentClient: currentClient)),
                                    );

                                   
                                  },
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20),
                                    elevation: 4,
                                    color: Theme.of(context).primaryColor,
                                    child: const Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Text(
                                        'Mua ngay',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (currentClient.role == "USER" &&
                      pet.statusPaid != 'NOTHING')
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        height: 50,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    isFavorite = !isFavorite;
                                  });
                                  Loading(context);
                                  await favoritePet(pet.id);
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop();
                                },
                                child: Material(
                                  borderRadius: BorderRadius.circular(20),
                                  elevation: 4,
                                  color: Colors.amber,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Icon(
                                      isFavorite
                                          ? FontAwesomeIcons.solidHeart
                                          : FontAwesomeIcons.heart,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20),
                                    elevation: 4,
                                    color: Colors.amber,
                                    child: const Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Text(
                                        'Đã bán',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  //HIỂN THỊ 2 BUTTON CỦA USER

                  if (currentClient.role == 'CENTER' &&
                      pet.statusPaid == 'NOTHING')
                    MaterialButton(
                      color: Theme.of(context).primaryColor,
                      minWidth: double.infinity,
                      height: 40,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPetScreen(pet: pet),
                          ),
                        );
                      },
                      // defining the shape
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text(
                        "Chỉnh sửa",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    )
                  // : const SizedBox(
                  //     height: 0,
                  //   ),

                  else if (pet.statusPaid == 'PAID')
                    MaterialButton(
                      color: Colors.white,
                      padding: const EdgeInsets.all(10),

                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReviewProfileScreen(
                                      centerId: pet.centerId!.id,
                                    )));
                      },
                      // defining the shape
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(0)),
                      child: const Text(
                        "Xem Đánh giá/ Phản hồi",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.green),
                      ),
                    )
                  else if (currentClient.role == 'CENTER' &&
                      pet.statusPaid == 'PENDING')
                    MaterialButton(
                      color: Colors.white,
                      padding: const EdgeInsets.all(10),

                      onPressed: () {},
                      // defining the shape
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(0)),
                      child: const Text(
                        "Đang có người mua",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.green),
                      ),
                    )
                ],
              ),

              //THÔNG TIN PET
            );
          }
        });
  }

  Widget CustomModalBottomSheet(BuildContext context, pet) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Chi tiết thú cưng',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildRow('Mã thú cưng:', '${pet.id}'),
                _buildRow('Tên:', '${pet.namePet}'),
                _buildRow('Giống:', '${pet.breed}'),
                _buildRow('Giá:', '${pet.price}'),
                _buildRow('Tuổi:', '2 weeks'),
                _buildRow('Cân nặng:', '${pet.weight}'),
                _buildRowColors('Màu sắc:', pet.color),
                _buildRow('Xuất xứ:', '${pet.original}'),
                // Add more rows as needed
              ],
            ),
          ),

          //button 'Đồng ý'
          Container(
            width: MediaQuery.of(context)
                .size
                .width, // Chiều dài bằng với độ rộng của màn hình
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                    Theme.of(context).primaryColor, // Màu của văn bản
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),

              onPressed: () {
                // Xử lý khi nút được nhấn
                Navigator.of(context).pop();
              },
              child: Text('Đồng ý'), // Văn bản của nút
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _buildRowColors(String title, List<dynamic> values) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Text(
              values.join(', '), // Join the list elements into a single string
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  void showInfoInputDialog(BuildContext context, String id) {
    TextEditingController infoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mô tả'),
          content: TextField(
            controller: infoController,
            decoration: const InputDecoration(hintText: 'Mô tả thú cưng'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                if (infoController.text.toString().isEmpty) {
                  notification('Mô tả không được để trống!', true);
                  return;
                }
                // Loading(context);
                // await createAdopt(
                //     widget.currentId.id, infoController.text.toString());
                // // ignore: use_build_context_synchronously
                // Navigator.of(context).pop();
              },
              child: const Text('Adopt'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(
      IconData icon, String title, String hintText, String aboutPetInfor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: _getColorIcon(title)),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            aboutPetInfor,
            maxLines: null,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorIcon(String colorString) {
    switch (colorString) {
      case 'Hướng dẫn nuôi:':
        return Colors.blue; // Example color
      case 'Lưu ý:':
        return Colors.red; // Example color
      case 'Sở thích:':
        return Colors.green; // Example color
      case 'Tiêm chủng:':
        return Colors.orange; // Example color
      default:
        return Colors.black; // Default color
    }
  }

  //sử dụng slider
  Widget _slider(List imageList) {
    return Stack(
      children: [
        CarouselSlider(
          items: imageList
              .map(
                (item) => Image.network(
                  item,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.infinity,
                ),
              )
              .toList(),
          carouselController: carouselController,
          options: CarouselOptions(
            scrollPhysics: const BouncingScrollPhysics(),
            autoPlay: true,
            //điều chỉnh tỉ lệ ảnh hiển thị
            aspectRatio: MediaQuery.of(context).size.height *
                0.56 /
                MediaQuery.of(context).size.width,
            viewportFraction: 1,

            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),

        //cấu hình nút chạy ảnh
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imageList.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => carouselController.animateToPage(entry.key),
                child: Container(
                  width: currentIndex == entry.key ? 17 : 7,
                  height: 7.0,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 3.0,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          currentIndex == entry.key ? Colors.red : Colors.teal),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Future<void> _showDeleteConfirmationDialog(String petId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc muốn xóa thú cưng không?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                Loading(context);
                await deletePet(petId);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
                // Navigator.of(context).pop();
                // Navigator.of(context).pop();
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }
}
