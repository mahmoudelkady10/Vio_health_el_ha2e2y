import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'base_api.dart';

class RegisterApi extends BaseApiManagement {
  static Future<http.Response> register(
      BuildContext context,
      String? email,
      String? username,
      String? password,
      String? gender,
      DateTime dateOfBirth,
      String? phoneNumber,
      String? weight,
      String? bloodGroup) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateOfBirth);

    var jsonBody = {
      'user_email': email.toString(),
      'user_name': username.toString(),
      'user_password': password.toString(),
      'gender': gender.toString().toLowerCase(),
      'birth_date': formattedDate,
      'phoneNumber': phoneNumber.toString(),
      'weight': weight.toString(),
      'blood_type': bloodGroup.toString()
    };
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/mob_create_user'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(jsonBody),
    );
    print(response.body);
    int responseStatus = json.decode(response.body)['result']['status'];

    return response;
  }
}
