import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/models/pet.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/pet_center_screens/test_notification.dart';
import 'package:found_adoption_application/services/center/petApi.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:found_adoption_application/utils/loading.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditPetScreen extends StatefulWidget {
  final Pet pet;
  const EditPetScreen({super.key, required this.pet});
  @override
  // ignore: library_private_types_in_public_api
  _EditPetScreenState createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  final _namePetController = TextEditingController();
  final _breedController = TextEditingController();
  final _colorController = TextEditingController();
  final _weightController = TextEditingController();
  final _originalController = TextEditingController();
  final _priceController = TextEditingController();
  final _hobbiesController = TextEditingController();
  final _attentionController = TextEditingController();
  final _instructionController = TextEditingController();
  final _inoculationController = TextEditingController();

  final _ageController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? birthday;

  String _selectedPetType = '';
  String _selectedGender = '';
  late bool isFreeOptionSelected;
  String price = '0';

  int currentIndex = 0;
  final CarouselController carouselController = CarouselController();
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  List<dynamic> finalResult = [];
  List<dynamic> _selectedColors = [];

  final ScrollController _scrollController = ScrollController();

  //thông báo
  final NotificationHandler notificationHandler = NotificationHandler();
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

  @override
  void initState() {
    super.initState();
    isFreeOptionSelected = widget.pet.free;
    notificationHandler.initializeNotifications();
    _namePetController.text = widget.pet.namePet;
    _breedController.text = widget.pet.breed;
    _weightController.text = widget.pet.weight;
    _originalController.text = widget.pet.original;

    _priceController.text = widget.pet.price;
    _attentionController.text = widget.pet.attention;
    _hobbiesController.text = widget.pet.hobbies;
    _inoculationController.text = widget.pet.inoculation;
    _instructionController.text = widget.pet.instruction;

    birthday = widget.pet.birthday;
    // _selectedLevel = widget.pet.level;
    _selectedPetType = widget.pet.petType;
    _selectedGender = widget.pet.gender;
    _selectedColors = widget.pet.color;
    finalResult.addAll(widget.pet.images);
  }

  Future<void> selectImage() async {
    List<dynamic> finalResult2 = [];
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    if (mounted) {
      setState(() {
        finalResult = finalResult2;
      });
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

  Future<void> handlerUpdatePet() async {
    if (mounted) {
      await updatePet(
          _namePetController.text.toString(),
          _selectedPetType,
          _breedController.text.toString(),
          double.parse(_ageController.text),
          _selectedGender,
          _colorController.text.toString(),
          _descriptionController.text.toString(),
          // _selectedLevel,
          imageFileList,
          imageFileList.isNotEmpty ? true : false,
          widget.pet.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) {
      return Container(); // Return an empty container if widget is disposed
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Edit Pet',
            style: TextStyle(color: Color.fromRGBO(48, 96, 96, 1.0))),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () async {
            var currentClient = await getCurrentClient();
            // ignore: use_build_context_synchronously
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
              if (finalResult.isNotEmpty && imageFileList.isEmpty)
                _slider(finalResult, true)
              else if (finalResult.isNotEmpty && imageFileList.isNotEmpty ||
                  finalResult.isEmpty && imageFileList.isNotEmpty)
                _slider(imageFileList, false)
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
                              price = value.toString();
                            });
                          },
                          controller: _priceController,
                          decoration: InputDecoration(
                            hintText: 'Enter price ...',
                            hintStyle: TextStyle(fontSize: 14),
                            border: InputBorder.none,
                            suffixText: 'vnd',
                            suffixStyle: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      )
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
                              labelText: 'Pet Name',
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
                              labelText: 'Breed',
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
                              labelText: 'Weight',
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
                              labelText: 'Original',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // TextField(
              //   controller: _namePetController,
              //   decoration: const InputDecoration(labelText: 'Pet Name'),
              // ),
              // TextField(
              //   controller: _breedController,
              //   decoration: const InputDecoration(labelText: 'Breed'),
              // ),
              Row(
                children: [
                  const Text('Type:'),
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

              // Your other form fields go here

              Row(
                children: [
                  const Text('Gender:'),
                  Radio(
                    value: 'MALE',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value.toString();
                      });
                    },
                  ),
                  const Text('Male'),
                  Radio(
                    value: 'FEMALE',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value.toString();
                      });
                    },
                  ),
                  const Text('Female'),
                  Radio(
                    value: 'ORTHER',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value.toString();
                      });
                    },
                  ),
                  const Text('Orther'),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              //ABOUT PET
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
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
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MenuFrameCenter(centerId: currentClient.id)));
                    },
                    // ignore: sort_child_properties_last
                    child: const Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      // ignore: deprecated_member_use
                      primary: const Color.fromARGB(255, 241, 189,
                          186), // Specify background color for the cancel button
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_namePetController.text == '' ||
                          _breedController.text == '' ||
                          _colorController.text == '' ||
                          _ageController.text == '' ||
                          _descriptionController.text == '' ||
                          _selectedPetType == '' ||
                          _selectedGender == '') {
                        notification(
                            'Please fill in all the information', true);
                        return;
                      }
                      // Create a new Pet object with the entered information
                      Loading(context);
                      await handlerUpdatePet();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Edit Pet'),
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

  Widget _buildInfoRow(
      IconData icon, String title, String hintText, TextEditingController aboutPetInfor) {
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
            controller: aboutPetInfor
            ,
            maxLines: null, 
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _slider(List imageList, bool isUpload) {
    return Stack(
      children: [
        CarouselSlider(
          items: isUpload
              ? imageList
                  .map(
                    (item) => Center(
                        child: InkWell(
                            onTap: () async {
                              await selectImage();
                            },
                            child: Image.network(
                              item,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ))),
                  )
                  .toList()
              : imageList
                  .map(
                    (item) => Center(
                      child: InkWell(
                        onTap: () async {
                          await selectImage();
                        },
                        child: Image(
                          image: FileImage(
                            File(item.path),
                          ),
                        ),
                      ),
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

  @override
  void dispose() {
    _namePetController.dispose();
    _breedController.dispose();
    _colorController.dispose();
    _ageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
