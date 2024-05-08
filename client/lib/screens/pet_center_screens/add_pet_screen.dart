import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/pet_center_screens/test_notification.dart';
import 'package:found_adoption_application/services/center/petApi.dart';
import 'package:found_adoption_application/services/image/multi_image_api.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:found_adoption_application/utils/loading.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _AddPetScreenState createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _namePetController = TextEditingController();
  final _breedController = TextEditingController();
  final _weightController = TextEditingController();
  final _originalController = TextEditingController();
  final _instructionController = TextEditingController();
  final _attentionController = TextEditingController();
  final _hobbiesController = TextEditingController();
  final _inoculationController = TextEditingController();

  final _ageController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? birthday;

  String _selectedPetType = '';
  String _selectedGender = '';

  int currentIndex = 0;
  final CarouselController carouselController = CarouselController();
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  List<dynamic> finalResult = [];

  final ScrollController _scrollController = ScrollController();

  //thông báo
  final NotificationHandler notificationHandler = NotificationHandler();
  // ignore: prefer_typing_uninitialized_variables
  var currentClient;

  bool isFreeOptionSelected = true;
  String price = '0';

  final List<dynamic> _selectedColors = ['Yellow'];

  final List<String> _colors = [
    'Red',
    'Green',
    'Blue',
    'Yellow',
    'Orange',
    'White',
    'Black',
    'Brown',
    'Grey'
  ];

  @override
  void initState() {
    super.initState();
    notificationHandler.initializeNotifications();
    getClient();
  }

  Future<void> getClient() async {
    var temp = await getCurrentClient();
    setState(() {
      currentClient = temp;
    });
  }

  Future<void> selectImage() async {
    List<dynamic> finalResult2 = [];

    final List<XFile> selectedImages = await imagePicker.pickMultiImage();

    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    // ignore: use_build_context_synchronously
    Loading(context);
    var result = await uploadMultiImage(imageFileList);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    finalResult2 = result.map((url) => url).toList();
    if (mounted) {
      setState(() {
        finalResult = finalResult2;
      });
    }
  }

  void _onColorSelected(String? color) {
    setState(() {
      if (color != null) {
        if (_selectedColors.contains(color)) {
          _selectedColors.remove(color);
        } else {
          _selectedColors.add(color);
        }
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900), // Only allow dates after today
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        birthday = picked;
      });
    }
  }

  Future<void> postPet() async {
    if (mounted) {
      // print('coi thử: ${_selectedColors.map((color) => "'$color'").toList()}');
      var colorsJson = jsonEncode(_selectedColors);

      await addPet(
          currentClient.id,
          null,
          null,
          null,
          _namePetController.text.toString(),
          _selectedPetType,
          _breedController.text.toString(),
          birthday!,
          _selectedGender,
          jsonDecode(colorsJson),
          _inoculationController.text.toString(),
          _instructionController.text.toString(),
          _attentionController.text.toString(),
          _hobbiesController.text.toString(),
          _originalController.text.toString(),
          price,
          isFreeOptionSelected,
          finalResult,
          _weightController.text.toString());
    }
    setState(() {
      imageFileList = [];
      _namePetController.clear();
      _breedController.clear();
      isFreeOptionSelected = true;
      _ageController.clear();
      _descriptionController.clear();
    });
    // Kéo giao diện lên trên cùng
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);

    await notificationHandler.showNotification();
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) {
      return Container(); // Return an empty container if widget is disposed
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Thêm thú cưng',
            style: TextStyle(color: Color.fromRGBO(48, 96, 96, 1.0))),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () async {
            var currentClient = await getCurrentClient();
            Navigator.push(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MenuFrameCenter(centerId: currentClient.id)));
          },
          icon: const Icon(
            FontAwesomeIcons.bars,
            size: 25,
            color: Color.fromRGBO(48, 96, 96, 1.0),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageFileList.isNotEmpty)
                if (imageFileList.length == 1)
                  Image.file(
                    File(imageFileList[0].path),
                    height: 350.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                else
                  _slider(finalResult)
              else
                Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[200],
                    // child: Icon(Icons.add_a_photo,
                    //     size: 50, color: Colors.grey[400],),

                    child: IconButton(
                      onPressed: selectImage,
                      icon: Icon(
                        Icons.add_a_photo,
                        size: 50,
                        color: Colors.grey[400],
                      ),
                    )),

              //THÔNG TIN GIÁ
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Chọn loại:',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Radio(
                          value: true,
                          groupValue: isFreeOptionSelected,
                          onChanged: (value) {
                            setState(() {
                              isFreeOptionSelected = value as bool;
                            });
                          },
                        ),
                        const Text('Miễn phí'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isFreeOptionSelected = false;
                      });
                    },
                    child: Row(
                      children: [
                        Radio(
                          value: false,
                          groupValue: isFreeOptionSelected,
                          onChanged: (value) {
                            setState(() {
                              isFreeOptionSelected = value as bool;
                            });
                          },
                        ),
                        const Text('Đặt giá'),
                      ],
                    ),
                  ),
                ],
              ),

              if (!isFreeOptionSelected)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                 
                      Container(
                        width: MediaQuery.of(context).size.width *
                            0.7, // Đặt chiều rộng của container

                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 18),
                          onChanged: (value) {
                            setState(() {
                              price = value.toString();
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Nhập giá ...',
                            hintStyle: TextStyle(fontSize: 14),
                            border: InputBorder.none,
                            suffixText: 'vnd',
                            suffixStyle: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                     
                    ],
                  ),
                ),

              const Text(
                'Thông tin cơ bản:',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),

              Table(
                columnWidths: const {
                  0: FractionColumnWidth(0.5),
                  1: FractionColumnWidth(0.5),
                },
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _namePetController,
                            decoration: const InputDecoration(
                              labelText: 'Tên thú cưng',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _breedController,
                            decoration: const InputDecoration(
                              labelText: 'Giống loài',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _weightController,
                            decoration: const InputDecoration(
                              labelText: 'Cân nặng (kg)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _originalController,
                            decoration: const InputDecoration(
                              labelText: 'Nguồn gốc',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Row(
                children: [
                  const Text('Loại:'),
                  Radio(
                    value: 'Cat',
                    groupValue: _selectedPetType,
                    onChanged: (value) {
                      setState(() {
                        _selectedPetType = value.toString();
                      });
                    },
                  ),
                  const Text('Mèo'),
                  Radio(
                    value: 'Dog',
                    groupValue: _selectedPetType,
                    onChanged: (value) {
                      setState(() {
                        _selectedPetType = value.toString();
                      });
                    },
                  ),
                  const Text('Chó'),
                ],
              ),
              // TextField(
              //   controller: _colorController,
              //   decoration: InputDecoration(labelText: 'Color'),
              // ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text("Ngày sinh (*): ",
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                  Text(
                      birthday != null
                          ? DateFormat('dd-MM-yyyy').format(birthday!.toLocal())
                          : 'Ngày sinh chưa được chọn',
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
              Divider(
                color: Colors.grey.shade200,
                thickness: 10,
                height: 10,
              ),

              // Your other form fields go here(

              //select color
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
                    title: const Text(
                      'Màu sắc:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 201, 121, 2)),
                    ),
                    trailing: DropdownButton<String>(
                      value: _selectedColors.last,
                      onChanged: _onColorSelected,
                      items: _colors.map((String color) {
                        return DropdownMenuItem<String>(
                          value: color,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 25,
                                height: 10,
                                color: _getColorFromString(color),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(color),
                              if (_selectedColors.contains(color))
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Selected colors',
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(
                      text: _selectedColors.join(', '),
                    ),
                    readOnly: true,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              Row(
                children: [
                  const Text(
                    'Giới tính:',
                    style: TextStyle(fontSize: 12),
                  ),
                  Radio(
                    value: 'MALE',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value.toString();
                      });
                    },
                  ),
                  const Text(
                    'Bé trai',
                    style: TextStyle(fontSize: 12),
                  ),
                  Radio(
                    value: 'FEMALE',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value.toString();
                      });
                    },
                  ),
                  const Text(
                    'Bé gái',
                    style: TextStyle(fontSize: 12),
                  ),
                  Radio(
                    value: 'ORTHER',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value.toString();
                      });
                    },
                  ),
                  const Text('Không xác định'),
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              // TextFormField(
              //   controller: _descriptionController,
              //   decoration: const InputDecoration(
              //       border: OutlineInputBorder(),
              //       hintText: 'Tell us about your pet',
              //       helperText: 'Keep it short, this is just demo',
              //       labelText: 'About Pet'),
              //   maxLines: 4,
              // ),

              //ABOUT PET
              const Text(
                'Thông tin thêm',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Card(
                    color: const Color.fromARGB(255, 250, 250, 250),
                    elevation: 4, // Add elevation for shadow effect
                    margin: const EdgeInsets.all(0), // No margin
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            Icons.assignment,
                            'Hướng dẫn nuôi:',
                            'Nhập hướng dẫn nuôi',
                            _instructionController,
                          ),
                          _buildInfoRow(
                            Icons.info,
                            'Lưu ý:',
                            'Nhập lưu ý',
                            _attentionController,
                          ),
                          _buildInfoRow(
                            Icons.favorite,
                            'Sở thích:',
                            'Nhập sở thích',
                            _hobbiesController,
                          ),
                          _buildInfoRow(
                            Icons.local_hospital,
                            'Tiêm chủng:',
                            'Nhập tiêm chủng',
                            _inoculationController,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      var currentClient = await getCurrentClient();
                      // Handle cancel button press
                      Navigator.push(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MenuFrameCenter(centerId: currentClient.id)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 241, 189,
                          186), // Specify background color for the cancel button
                    ),
                    child: const Text('Hủy'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_namePetController.text == '' ||
                          _breedController.text == '' ||
                          birthday == null ||
                          imageFileList.isEmpty ||
                          _selectedPetType == '' ||
                          _selectedGender == '') {
                        notification(
                            'Vui lòng điền đầy đủ thông tin', true);
                        return;
                      }
                      // Create a new Pet object with the entered information
                      Loading(context);
                      await postPet();
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    },
                    child: const Text('Tạo thú cưng'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorFromString(String colorString) {
    switch (colorString) {
      case 'Red':
        return Colors.red;
      case 'Green':
        return Colors.green;
      case 'Blue':
        return Colors.blue;
      case 'Yellow':
        return Colors.yellow;
      case 'Orange':
        return Colors.orange;
      case 'White':
        return const Color.fromARGB(255, 245, 242, 242);
      case 'Black':
        return Colors.black;
      case 'Brown':
        return Colors.brown;
      case 'Grey':
        return Colors.grey;
      default:
        return Colors.transparent;
    }
  }

  Widget _buildInfoRow(IconData icon, String title, String hintText,
      TextEditingController abouPetController) {
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
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          TextField(
            controller: abouPetController,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
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

  Widget _slider(List imageList) {
    return Stack(
      children: [
        CarouselSlider(
          items: imageList
              .map(
                (item) => Image.network(
                  item,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
              .toList(),
          carouselController: carouselController,
          options: CarouselOptions(
            scrollPhysics: const BouncingScrollPhysics(),
            autoPlay: true,
            //điều chỉnh tỉ lệ ảnh hiển thị
            aspectRatio: 20 / 20,
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

  @override
  void dispose() {
    _namePetController.dispose();
    _breedController.dispose();

    _ageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
