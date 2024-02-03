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
  final _colorController = TextEditingController();

  final _ageController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? dropdownValue;

  String _selectedPetType = '';
  String _selectedGender = '';
  String _selectedLevel = 'NORMAL';
  DateTime? birthday;

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

  Future<void> postPet() async {
    // print('test images here: $finalResult');

    // Kiểm tra trạng thái mounted trước khi gọi setState
    if (mounted) {
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
          _colorController.text.toString(),
          finalResult,
          _descriptionController.text.toString(),
          _selectedLevel);
    }
    setState(() {
      imageFileList = [];
      _namePetController.clear();
      _breedController.clear();
      _colorController.clear();
      _ageController.clear();
      _descriptionController.clear();
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

              TextField(
                controller: _namePetController,
                decoration: const InputDecoration(
                    labelText: 'Pet Name (*)', fillColor: Colors.red),
              ),
              TextField(
                controller: _breedController,
                decoration: const InputDecoration(labelText: 'Breed (*)'),
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
              TextField(
                controller: _colorController,
                decoration: const InputDecoration(labelText: 'Color (*)'),
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

              Row(
                children: [
                  const Text("Select link Center (*): ",
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                  Expanded(
                    child: DropdownButton<String>(
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
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Tell us about your pet',
                    helperText: 'Keep it short, this is just demo',
                    labelText: 'About Pet'),
                maxLines: 4,
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
                          _colorController.text == '' ||
                          birthday == null ||
                          _descriptionController.text == '' ||
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
    _colorController.dispose();
    _ageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
