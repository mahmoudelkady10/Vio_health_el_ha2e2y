import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medic_app/model/medication_model.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/base_api.dart';
import 'package:provider/provider.dart';

class MedicationApi extends BaseApiManagement {
  static Future<List<MedicationModel>> getMedication(
      BuildContext context, int appId) async {
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/mob_get_medications'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'appointment_id': appId,
        "token": Provider.of<UserModel>(context, listen: false).token

      }),
    );
    print(response.body);
    int responseStatus = json.decode(response.body)['result']['status'];
    List<MedicationModel> medicationList = [];
    if (responseStatus == 200) {
      for (var index in json.decode(response.body)['result']['data']) {
        medicationList.add(MedicationModel.fromJson(index));
      }
      print(medicationList);
      return medicationList;
    } else {
      throw Exception('Error Failed to get medication');
    }
  }
}