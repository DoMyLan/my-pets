import 'dart:convert';

import 'package:found_adoption_application/services/auth_api.dart';
import 'package:http/http.dart' as http;

Future<dynamic> callBackApi(apiUrl, method, body) async {
  var newAccessToken = await refreshAccessToken();
  var response;
  if (method == "POST") {
    response = await http.post(apiUrl,
        headers: {
          'Authorization': 'Bearer $newAccessToken',
          'Content-Type': 'application/json',
        },
        body: body);
  } else if (method == "PUT") {
    response = await http.put(apiUrl,
        headers: {
          'Authorization': 'Bearer $newAccessToken',
          'Content-Type': 'application/json',
        },
        body: body);
  } else if (method == "GET") {
    response = await http.get(apiUrl, headers: {
      'Authorization': 'Bearer $newAccessToken',
      'Content-Type': 'application/json',
    });
  }
  return json.decode(response.body);
}

Future<List<dynamic>> callBackApiListDynamic(apiUrl, method, body) async {
  var newAccessToken = refreshAccessToken().toString();
  var response;
  if (method == "post") {
    response = await http.post(apiUrl,
        headers: {
          'Authorization': 'Bearer $newAccessToken',
          'Content-Type': 'application/json',
        },
        body: body);
  } else if (method == "put") {
    response = await http.put(apiUrl,
        headers: {
          'Authorization': 'Bearer $newAccessToken',
          'Content-Type': 'application/json',
        },
        body: body);
  } else if (method == "get") {
    response = await http.get(apiUrl, headers: {
      'Authorization': 'Bearer $newAccessToken',
      'Content-Type': 'application/json',
    });
  }
  return json.decode(response.body) as List<dynamic>;
}