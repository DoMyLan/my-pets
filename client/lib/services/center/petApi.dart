import 'dart:convert';
import 'package:found_adoption_application/models/breed_model.dart';
import 'package:found_adoption_application/models/centerLoad.dart';
import 'package:found_adoption_application/models/center_hot_model.dart';
import 'package:found_adoption_application/models/pet.dart';
import 'package:found_adoption_application/services/api.dart';
import 'package:found_adoption_application/services/image/multi_image_api.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

Future<void> addPet(
  String? centerId,
  String? giver,
  String? rescue,
  String? linkCenter,
  String namePet,
  String petType,
  String breed,
  DateTime birthday,
  String gender,
  List<dynamic> color,
  String inoculation,
  String instruction,
  String attention,
  String hobbies,
  String original,
  String price,
  bool free,
  List<dynamic> imagePaths,
  String weight,
) async {
  var responseData = {};
  var body = jsonEncode({
    "centerId": centerId,
    "giver": giver,
    "rescue": rescue,
    "linkCenter": linkCenter,
    "namePet": namePet,
    "petType": petType,
    "breed": breed,
    "birthday": DateFormat("MM-dd-yyyy").format(birthday),
    "gender": gender,
    "color": color,
    "inoculation": inoculation,
    "instruction": instruction,
    "attention": attention,
    "hobbies": hobbies,
    "original": original,
    "price": price,
    "free": free,
    "images": imagePaths,
    "weight": weight,
  });

  try {
    responseData = await api('pet', 'POST', body);

    if (responseData['success']) {
      notification(responseData['message'], false);
    } else {
      notification(responseData['message'], true);
    }
  } catch (e) {
    print('faillll: $e');
    //  notification(e.toString(), true);
  }
}

Future<List<Pet>> getAllPet() async {
  var currentClient = await getCurrentClient();
  var responseData;
  final apiUrl;

  try {
    if (currentClient.role == 'USER') {
      apiUrl = "pet/all/pets/center";
    } else {
      apiUrl = "pet/${currentClient.id}";
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

Future<List<Pet>> getAllPetPersonal() async {
  var currentClient = await getCurrentClient();
  var responseData;
  final apiUrl;

  try {
    if (currentClient.role == 'USER') {
      apiUrl = "pet/all/pets/personal";
    } else {
      apiUrl = "pet/${currentClient.id}";
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

Future<List<Pet>?> getAllPetOfCenter(centerId) async {
  var responseData;
  List<Pet>? pets;
  try {
    final apiUrl = "pet/$centerId";
    responseData = await api(apiUrl, "GET", '');
    var petList = responseData['data'] as List<dynamic>;
    pets = petList.map((json) => Pet.fromJson(json)).toList();
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
    return null;
  }

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
    if (age.length > 1) {
      ageSearch = "&age=" + age[0].toString();
      ageSearch = ageSearch + '&age=' + age[age.length - 1].toString();
    } else if (age.length == 1) {
      ageSearch = "&age=" + age[0].toString() + ".0";
    }
  }

  try {
    final apiUrl =
        "pet/search/find?breed=$breedSearch&color=$colorSearch$ageSearch";
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
    final apiUrl = "pet/${petId}";
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
    "age": age.toString(),
    "gender": gender,
    "color": color,
    "description": description,
    // "level": level,
    if (isNewUpload) "images": finalResult,
  });
  try {
    responseData = await api('pet/$petId', 'PUT', body);
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

Future<List<CenterLoad>> loadCenterAll() async {
  var responseData;
  var currentClient = await getCurrentClient();
  try {
    const apiUrl = "pet/centers/all";
    responseData = await api(apiUrl, "GET", '');
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
  var centerList = responseData['data'] as List<dynamic>;
  List<CenterLoad> centers = centerList
      .map((json) => CenterLoad.fromJson(json, currentClient.location))
      .toList();
  return centers;
}

Future<void> favoritePet(petId) async {
  var responseData;
  var body = jsonEncode({
    "petId": petId,
  });
  try {
    const apiUrl = "pet/favorite/pet";
    responseData = await api(apiUrl, "PUT", body);
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

Future<List<Pet>> getPetFavorite() async {
  var responseData;

  try {
    final apiUrl = "pet/favorite/pet";
    responseData = await api(apiUrl, "GET", '');
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
  var petList = responseData['data'] as List<dynamic>;
  List<Pet> pets = petList.map((json) => Pet.fromJson(json)).toList();
  return pets;
}

Future<Pet> getPet(petId) async {
  var responseData;
  try {
    final apiUrl = "pet/one/$petId";
    responseData = await api(apiUrl, "GET", '');
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
  var pet = Pet.fromJson(responseData['data']);
  return pet;
}

Future<List<PetCustom>> getPetCenterPost(centerId) async {
  // ignore: prefer_typing_uninitialized_variables
  var responseData;
  try {
    final apiUrl = "pet/center/$centerId";
    responseData = await api(apiUrl, "GET", '');
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
  var petList = responseData['data'] as List<dynamic>;
  List<PetCustom> pets =
      petList.map((json) => PetCustom.fromJson(json)).toList();
  return pets;
}

Future<List<Breed>> getBreed(typePet) async {
  // ignore: prefer_typing_uninitialized_variables
  var responseData;
  try {
    final apiUrl = "pet/breed/list?petType=$typePet";
    responseData = await api(apiUrl, "GET", '');
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
  var breedList = responseData['data'] as List<dynamic>;
  List<Breed> breeds =
      breedList.map((json) => Breed.fromJson(json)).toList();
  return breeds;
}

Future<List<CenterHot>> getCenterHot() async {
  // ignore: prefer_typing_uninitialized_variables
  var responseData;
  try {
    const apiUrl = "center/hot/list";
    responseData = await api(apiUrl, "GET", '');
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
  var centerList = responseData['data'] as List<dynamic>;
  List<CenterHot> centers =
      centerList.map((json) => CenterHot.fromJson(json)).toList();
  return centers;
}
