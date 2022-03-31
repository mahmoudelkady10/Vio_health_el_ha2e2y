import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medic_app/model/user_model.dart';
import 'base_api.dart';
import 'package:provider/provider.dart';

class EditProfileApi extends BaseApiManagement {
  static Future<http.Response> editProfile(BuildContext context, int partnerId, String name, String email, String bloodGroup,
      String weight, String gender, String image) async {
    var jsonBody = {
      "partner_id": partnerId,
      "name": name,
      "email": email,
      "image": image,
      "token": Provider.of<UserModel>(context, listen: false).token

    };

    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/mob_edit_profile'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(jsonBody),
    );

    return response;
  }
}
