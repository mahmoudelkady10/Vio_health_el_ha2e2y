import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medic_app/model/specialties_model.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/base_api.dart';
import 'package:provider/provider.dart';

class SpecialtiesApi extends BaseApiManagement {
  static Future<List<SpecialtiesModel>> getSpecialties(
      BuildContext context) async {
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/mob_get_specialties'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "token": Provider.of<UserModel>(context, listen: false).token
      }),
    );
    print(response.body);
    int responseStatus = json.decode(response.body)['result']['status'];
    List<SpecialtiesModel> specialtiesList = [];
    if (responseStatus == 200) {
      for (var index in json.decode(response.body)['result']['data']) {
        specialtiesList.add(SpecialtiesModel.fromJson(index));
      }
      Provider.of<SpecialtiesList>(context, listen: false).specialties =
          specialtiesList;
      return specialtiesList;
    } else {
      throw Exception('Errrr Failed to get specialties');
    }
  }
}
