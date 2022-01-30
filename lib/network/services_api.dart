import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medic_app/model/services_model.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/base_api.dart';
import 'package:provider/provider.dart';

class ServicesApi extends BaseApiManagement {
  static Future<List<ServicesModel>> getServices(BuildContext context) async {
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/mob_get_services'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {"token": Provider.of<UserModel>(context, listen: false).token}),
    );
    print(response.body);
    int responseStatus = json.decode(response.body)['result']['status'];
    List<ServicesModel> servicesList = [];
    if (responseStatus == 200) {
      for (var index in json.decode(response.body)['result']['data']) {
        servicesList.add(ServicesModel.fromJson(index));
      }
      print(servicesList.length);
      return servicesList;
    } else {
      throw Exception('Errrr Failed to get services');
    }
  }
}
