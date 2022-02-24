import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medic_app/model/city_model.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/base_api.dart';
import 'package:provider/provider.dart';

class CityApi extends BaseApiManagement {
  static Future<List<CityModel>> getCity(BuildContext context) async {
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/techclinic/get_city'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "token": Provider.of<UserModel>(context, listen: false).token
      }),
    );
    print(response.body);
    int responseStatus = json.decode(response.body)['result']['status'];
    List<CityModel> cityList = [];
    if (responseStatus == 200) {
      for (var index in json.decode(response.body)['result']['data']) {

        cityList.add(CityModel.fromJson(index));
      }
      return cityList;
    } else {
      throw Exception('Errrr Failed to get specialties');
    }
  }
}
