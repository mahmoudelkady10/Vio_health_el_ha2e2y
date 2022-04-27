import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medic_app/model/doctors_model.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/base_api.dart';
import 'package:provider/provider.dart';

class SearchFilterApi extends BaseApiManagement {
  static Future<List<DoctorsModel>> get_doctors_search(BuildContext context,
      dynamic governorate, dynamic city, dynamic specialty_id) async {
    var jsonBody = jsonEncode({
      "token": Provider.of<UserModel>(context, listen: false).token,
      "governorate": governorate,
      "city": city,
      "specialty_id": specialty_id,
    });
    if (governorate == '' && city == '') {
      jsonBody = jsonEncode({
        "token": Provider.of<UserModel>(context, listen: false).token,
        "specialty_id": specialty_id,
      });
    } else if (governorate == '' && specialty_id == '') {
      jsonBody = jsonEncode({
        "token": Provider.of<UserModel>(context, listen: false).token,
        "city": city,
      });
    } else if (city == '' && specialty_id == '') {
      jsonBody = jsonEncode({
        "token": Provider.of<UserModel>(context, listen: false).token,
        "governorate": governorate,
      });
    } else if (governorate == '') {
      jsonBody = jsonEncode({
        "token": Provider.of<UserModel>(context, listen: false).token,
        "city": city,
        "specialty_id": specialty_id,
      });
    } else if (city == '') {
      jsonBody = jsonEncode({
        "token": Provider.of<UserModel>(context, listen: false).token,
        "governorate": governorate,
        "specialty_id": specialty_id,
      });
    } else if (specialty_id == '') {
      jsonBody = jsonEncode({
        "token": Provider.of<UserModel>(context, listen: false).token,
        "governorate": governorate,
        "city": city,
      });
    } else {
      jsonBody = jsonEncode({
        "token": Provider.of<UserModel>(context, listen: false).token,
        "governorate": governorate,
        "city": city,
        "specialty_id": specialty_id,
      });
    }

    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/techclinic/get_doctors_search'),
      headers: {"Content-Type": "application/json"},
      body: jsonBody,
    );
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
