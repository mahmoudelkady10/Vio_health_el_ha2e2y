import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medic_app/model/user_model.dart';
import 'base_api.dart';
import 'package:provider/provider.dart';

class AppointmentAction extends BaseApiManagement {
  static Future<http.Response> cancelAppoint(BuildContext context, int appId) async {
    var jsonBody = {
      "app_id": appId,
      "token": Provider.of<UserModel>(context, listen: false).token
    };

    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/mob_cancel_appointment'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(jsonBody),
    );
    print(response.body);
    return response;
  }
  static Future<http.Response> confirmAppoint(BuildContext context, int appId) async {
    var jsonBody = {
      "app_id": appId,
      "token": Provider.of<UserModel>(context, listen: false).token

    };

    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/mob_confirm_appointment'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(jsonBody),
    );
    print(response.body);
    return response;
  }
}
