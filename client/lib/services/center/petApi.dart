import 'dart:convert';
import 'package:found_adoption_application/models/pet.dart';
import 'package:found_adoption_application/services/api.dart';
import 'package:found_adoption_application/services/image/multi_image_api.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';
import 'package:image_picker/image_picker.dart';

Future<void> addPet(
  String namePet,
  String petType,
  String breed,
  double age,
  String gender,
  String color,
  List<dynamic> imagePaths,
  String description,
  String level,
) async {
  var responseData = {};
  var body = jsonEncode({
    "namePet": namePet,
    "petType": petType,
    "breed": breed,
    "age": age,
    "gender": gender,
    "color": color,
    "images": imagePaths,
    "description": description,
    "level": level
  });

  try {
    responseData = await api('/pet', 'POST', body);

    if (responseData['success']) {
      notification(responseData['message'], false);
    } else {
      notification(responseData['message'], true);
    }
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
}

Future<List<Pet>> getAllPet() async {
  var currentClient = await getCurrentClient();
  var responseData;
  final apiUrl;

  try {
    if (currentClient.role == 'USER') {
      apiUrl = "/pet/all/pets";
    } else {
      apiUrl = "/pet/${currentClient.id}";
    }
    responseData = await api(apiUrl, "GET", '');
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
  var petList = responseData['data'] as List<dynamic>;
  List<Pet> pets = petList.map((json) => Pet.fromJson(json)).toList();
  return pets;


}

Future<List<Pet>> getAllPetOfCenter(centerId) async {
  var responseData;
  try {
    final apiUrl = "/pet/${centerId}";
    responseData = await api(apiUrl, "GET", '');
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
  var petList = responseData['data'] as List<dynamic>;
  List<Pet> pets = petList.map((json) => Pet.fromJson(json)).toList();
  return pets;
}

Future<List<Pet>> filterPet(breed, color, age) async {
  var responseData;
  var colorSearch = '';
  var ageSearch = '';
  var breedSearch = breed != null ? breed : '';

  if (color.isNotEmpty) {
    for (var i = 0; i < color.length; i++) {
      if (i == 0) {
        colorSearch = color[i];
      } else {
        colorSearch = colorSearch + '&color=' + color[i];
      }
    }
  }

  if (age.isNotEmpty) {
    for (var i = 0; i < age.length; i++) {
      if (i == 0) {
        ageSearch = age[i].toString();
      } else {
        ageSearch = ageSearch + '&age=' + age[i].toString();
      }
    }
  }

  try {
    final apiUrl =
        "/pet/search/find?breed=$breedSearch&color=$colorSearch&age=$ageSearch";
    responseData = await api(apiUrl, "GET", '');
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
  var petList = responseData['data'] as List<dynamic>;
  List<Pet> pets = petList.map((json) => Pet.fromJson(json)).toList();
  return pets;
}

Future<void> deletePet(petId) async {
  var responseData;
  try {
    final apiUrl = "/pet/${petId}";
    responseData = await api(apiUrl, "DELETE", '');
    if (!responseData['success']) {
      notification(responseData['message'], true);
      return;
    }
    notification(responseData['message'], false);
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
}

Future<void> updatePet(
    String namePet,
    String petType,
    String breed,
    double age,
    String gender,
    String color,
    String description,
    // String level,
    List<XFile> imagePaths,
    bool isNewUpload,
    String petId) async {
  var responseData = {};
  List<dynamic> finalResult = [];
  var result;

  if (imagePaths.isNotEmpty && isNewUpload) {
    result = await uploadMultiImage(imagePaths);
    finalResult = result.map((url) => url).toList();
  }

  var body = jsonEncode({
    "namePet": namePet,
    "petType": petType,
    "breed": breed,
    "age": age,
    "gender": gender,
    "color": color,
    "description": description,
    // "level": level,
    if (isNewUpload) "images": finalResult,
  });
  try {
    responseData = await api('/pet/$petId', 'PUT', body);
    if (responseData['success']) {
      notification(responseData['message'], false);
    } else {
      notification(responseData['message'], true);
    }
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
}
