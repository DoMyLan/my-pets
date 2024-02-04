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

  final _ageController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedPetType = '';
  String _selectedGender = '';
  // String _selectedLevel = 'NORMAL';

  int currentIndex = 0;
  final CarouselController carouselController = CarouselController();
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  List<dynamic> finalResult = [];

  final ScrollController _scrollController = ScrollController();

  //thông báo
  final NotificationHandler notificationHandler = NotificationHandler();

  @override
  void initState() {
    super.initState();
    notificationHandler.initializeNotifications();
    _namePetController.text = widget.pet.namePet;
    _breedController.text = widget.pet.breed;
    _colorController.text = widget.pet.color;
    _ageController.text = widget.pet.age.toString();
    _descriptionController.text = widget.pet.description;
    // _selectedLevel = widget.pet.level;
    _selectedPetType = widget.pet.petType;
    _selectedGender = widget.pet.gender;
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

              TextField(
                controller: _namePetController,
                decoration: const InputDecoration(labelText: 'Pet Name'),
              ),
              TextField(
                controller: _breedController,
                decoration: const InputDecoration(labelText: 'Breed'),
              ),
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
              TextField(
                controller: _colorController,
                decoration: const InputDecoration(labelText: 'Color'),
              ),

              TextField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
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
