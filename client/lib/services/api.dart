import 'dart:convert';
import 'package:found_adoption_application/services/callBackApi.dart';
import 'package:found_adoption_application/utils/consts.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:http/http.dart' as http;

Future<dynamic> api(path, method, body) async {
  var currentClient = await getCurrentClient();
  var accessToken = currentClient.accessToken;
  Map<String, dynamic> responseData = {};

  try {
    final apiUrl = Uri.parse("$BASE_URL/$path");
    if (method == "GET") {
      var response = await http.get(apiUrl, headers: {
        'Authorization': 'Bearer ${accessToken}',
        'Content-Type': 'application/json',
      });
      responseData = await json.decode(response.body);
   

      if (responseData['message'] == 'jwt expired')
        responseData = await callBackApi(apiUrl, method, '') ;
      return responseData;
    } else if(method == "POST"){
      
      var response = await http.post(apiUrl, headers: {
        'Authorization': 'Bearer ${accessToken}',
        'Content-Type': 'application/json',
      }, body: body);
      
      responseData =await json.decode(response.body);
    

      if (responseData['message'] == 'jwt expired')
        responseData = await callBackApi(apiUrl, method, body) ;
    
      return responseData;
    } else if(method == "DELETE"){
      var response = await http.delete(apiUrl, headers: {
        'Authorization': 'Bearer ${accessToken}',
        'Content-Type': 'application/json',
      });
      responseData = json.decode(response.body);

      if (responseData['message'] == 'jwt expired')
        responseData = await callBackApi(apiUrl, method, body) ;
      return responseData;
    }
    else if(method == "PUT"){
      var response = await http.put(apiUrl, headers: {
        'Authorization': 'Bearer ${accessToken}',
        'Content-Type': 'application/json',
      }, body: body);
      responseData = json.decode(response.body);

      if (responseData['message'] == 'jwt expired')
        responseData = await callBackApi(apiUrl, method, body) ;
      return responseData;
    }
  } catch (e) {
    print('API fail:$e');
    return false;
  }
}
