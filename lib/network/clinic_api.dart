import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medic_app/model/clinic_model.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/base_api.dart';
import 'package:provider/provider.dart';

class ClinicApi extends BaseApiManagement {
  static Future<List<ClinicModel>> getClinics(
      BuildContext context, int doctorId) async {
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/techclinic/mob_get_clinics'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "token": Provider.of<UserModel>(context, listen: false).token,
        "uid": Provider.of<UserModel>(context, listen: false).uid,
        "doctor_id": doctorId
      }),
    );
    print(response.body);
    int responseStatus = json.decode(response.body)['result']['status'];
    List<ClinicModel> clinicList = [];
    if (responseStatus == 200) {
      for (var index in json.decode(response.body)['result']['data']) {
        clinicList.add(ClinicModel.fromJson(index));
      }
      print(clinicList.length);
      return clinicList;
    } else {
      throw Exception('Errrr Failed to get packages');
    }
  }
}
