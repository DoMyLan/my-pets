import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/models/centerLoad.dart';
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

class AddPetScreenPersonal extends StatefulWidget {
  const AddPetScreenPersonal({super.key});
  @override
  _AddPetScreenState createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreenPersonal> {
  final _namePetController = TextEditingController();
  final _breedController = TextEditingController();

  final _weightController = TextEditingController();
  final _originalController = TextEditingController();
  final _instructionController = TextEditingController();
  final _attentionController = TextEditingController();
  final _hobbiesController = TextEditingController();
  final _inoculationController = TextEditingController();

  final _ageController = TextEditingController();

  String? dropdownValue;

  String _selectedPetType = '';
  String _selectedGender = '';

  DateTime? birthday;

  bool isFreeOptionSelected = true;
  String price = '0';

  List<dynamic> _selectedColors = ['Yellow'];

  List<String> _colors = [
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

  int currentIndex = 0;
  final CarouselController carouselController = CarouselController();
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  List<dynamic> finalResult = [];
  ScrollController _scrollController = ScrollController();
  var currentClient;
  List<CenterLoad>? centers = <CenterLoad>[
    const CenterLoad(id: '1', name: 'Center 1', distance: '1km'),
  ];

  //thông báo
  final NotificationHandler notificationHandler = NotificationHandler();

  @override
  void initState() {
    super.initState();
    notificationHandler.initializeNotifications();
    getClient();
    loadCenter();
  }

  Future<void> getClient() async {
    var temp = await getCurrentClient();
    setState(() {
      currentClient = temp;
    });
  }

  Future<void> loadCenter() async {
    var temp = await loadCenterAll();
    setState(() {
      List<CenterLoad> sortedCenters = temp;
      centers = List.from(sortedCenters);
      sortedCenters.sort((a, b) =>
          double.parse(a.distance).compareTo(double.parse(b.distance)));
    });
    if (centers != null && centers!.isNotEmpty) {
      dropdownValue = centers![0].id;
    }
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

  Future<void> selectImage() async {
    List<dynamic> finalResult2 = [];

    final List<XFile> selectedImages = await imagePicker.pickMultiImage();

    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    Loading(context);
    var result = await uploadMultiImage(imageFileList);
    Navigator.of(context).pop();
    finalResult2 = result.map((url) => url).toList();

    // print('test selectedImage: $finalResult');

    // Check if the widget is still mounted before calling setState
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

  Future<void> postPet() async {
    // print('test images here: $finalResult');

    // Kiểm tra trạng thái mounted trước khi gọi setState
    if (mounted) {
      var colorsJson = jsonEncode(_selectedColors);
      // Call the API to post content with image paths
      await addPet(
          null,
          currentClient.id,
          null,
          dropdownValue,
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
 
    });
    // Kéo giao diện lên trên cùng
    _scrollController.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);

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
        title: const Text('Add a New Pet',
            style: TextStyle(color: Color.fromRGBO(48, 96, 96, 1.0))),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () async {
            var currentClient = await getCurrentClient();
            Navigator.push(
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
              SizedBox(
                height: 12,
              ),
              Text(
                'Choose an option:',
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
                        Text('Free'),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
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
                        Text('Set Price'),
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
                      SizedBox(height: 4),
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
                          style: TextStyle(fontSize: 18),
                          onChanged: (value) {
                            setState(() {
                              price = value;
                            });
                            print('price: $price');
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter price ...',
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

              Text(
                'Fill in the table with the needed information:',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),

              Table(
                columnWidths: {
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
                            decoration: InputDecoration(
                              labelText: 'Pet Name (*)',
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
                            decoration: InputDecoration(
                              labelText: 'Breed (*)',
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
                            decoration: InputDecoration(
                              labelText: 'Weight (*)',
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
                            decoration: InputDecoration(
                              labelText: 'Original (*)',
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
                  const Text('Type (*)'),
                  Radio(
                    value: 'Cat',
                    groupValue: _selectedPetType,
                    onChanged: (value) {
                      setState(() {
                        _selectedPetType = value.toString();
                      });
                    },
                  ),
                  const Text('Cat'),
                  Radio(
                    value: 'Dog',
                    groupValue: _selectedPetType,
                    onChanged: (value) {
                      setState(() {
                        _selectedPetType = value.toString();
                      });
                    },
                  ),
                  const Text('Dog'),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text("Birthday (*): ",
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                  Text(
                      birthday != null
                          ? DateFormat('dd-MM-yyyy').format(birthday!.toLocal())
                          : 'Date has not been selected',
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

              //select color
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      'Select color:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 201, 121, 2)),
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
                              SizedBox(
                                width: 20,
                              ),
                              Text(color),
                              if (_selectedColors.contains(color))
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Selected colors',
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(
                        text: _selectedColors.join(', '),
                      ),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              Row(
                children: [
                  const Text("Select link Center (*): ",
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                  Flexible(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: dropdownValue,
                      icon: const FittedBox(
                        fit: BoxFit.contain,
                        child: Icon(Icons.arrow_drop_down),
                      ),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      underline: Container(
                        height: 2,
                        color: Theme.of(context).primaryColor,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: centers!
                          .map<DropdownMenuItem<String>>((CenterLoad center) {
                        return DropdownMenuItem<String>(
                          value: center.id,
                          child: Flexible(
                            child: Text(
                              '${center.name} - ${center.distance}km',
                              softWrap: true,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              //DropdownButtonFormField LEVEL
              // DropdownButtonFormField<String>(
              //   value: _selectedLevel,
              //   onChanged: (String? value) {
              //     setState(() {
              //       _selectedLevel = value!;
              //     });
              //   },
              //   decoration: const InputDecoration(labelText: 'Level'),
              //   items: ['URGENT', 'NORMAL']
              //       .map<DropdownMenuItem<String>>((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(
              //         value,
              //         style: const TextStyle(
              //             color: Color.fromARGB(255, 192, 77, 36)),
              //       ),
              //     );
              //   }).toList(),
              // ),

              // Your other form fields go here

              Row(
                children: [
                  const Text(
                    'Gender:',
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
                    'Male',
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
                    'Female',
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
                  const Text('Unknown'),
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              //ABOUT PET
              Text(
                'About Pet:',
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
                    margin: EdgeInsets.all(0), // No margin
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
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MenuFrameCenter(centerId: currentClient.id)));
                    },
                    child: const Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 241, 189,
                          186), // Specify background color for the cancel button
                    ),
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
                            'Please fill in all the information', true);
                        return;
                      }
                      // Create a new Pet object with the entered information
                      Loading(context);
                      await postPet();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add Pet'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
        return Color.fromARGB(255, 245, 242, 242);
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

    super.dispose();
  }
}
