import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medic_app/model/user_model.dart';
import 'base_api.dart';
import 'package:provider/provider.dart';

class LoginApi extends BaseApiManagement {
  static Future<dynamic> login(
      BuildContext context, String? username, String? password) async {
    var jsonBody = {
      'username': username,
      'password': password,
    };
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/mob_signin'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(jsonBody),
    );
    dynamic responseStatus = json.decode(response.body)['result']['status'];
    print(response.body);
    if (responseStatus != 200) {
      // throw Exception('Error Failed to login!');
      return responseStatus;
    } else {
      UserModel user =
          UserModel.fromJson(json.decode(response.body)['result']['data']);
      Provider.of<UserModel>(context, listen: false).loginSetting(user);
      return responseStatus;
    }
  }

  static Future<dynamic> getUserInfo(BuildContext context, String token) async {
    var jsonBody = {
      'token': token,
    };
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/mob_maininfo'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(jsonBody),
    );
    print(jsonDecode(response.body));
    dynamic responseStatus = json.decode(response.body)['result']['status'];
    print(responseStatus);
    if (responseStatus != 200) {
      // throw Exception('Error Failed to login!');
      return responseStatus;
    } else {
      UserModel user =
          UserModel.fromJson(json.decode(response.body)['result']['data']);
      Provider.of<UserModel>(context, listen: false).loginSetting(user);
      return responseStatus;
    }
  }
}
