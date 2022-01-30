import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/base_api.dart';
import 'package:medic_app/model/doctors_model.dart';
import 'package:provider/provider.dart';

class DoctorsApi extends BaseApiManagement {
  static Future<List<DoctorsModel>> getDoctors(BuildContext context) async {
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/mob_get_doctors'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "token": Provider.of<UserModel>(context, listen: false).token
      }),
    );
    print(response.body);
    int responseStatus = json.decode(response.body)['result']['status'];
    List<DoctorsModel> doctorsList = [];
    if (responseStatus == 200) {
      for (var index in json.decode(response.body)['result']['data']) {

        doctorsList.add(DoctorsModel.fromJson(index));
      }
      return doctorsList;
    } else {
      throw Exception('Errrr Failed to get specialties');
    }
  }
}
