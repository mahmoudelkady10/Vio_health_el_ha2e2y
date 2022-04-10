import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medic_app/model/radiology_model.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/base_api.dart';
import 'package:provider/provider.dart';

class RadiologyApi extends BaseApiManagement {
  static Future<List<Radiology>> getRads(
      BuildContext context, int appId) async {
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/techclinic/mob_get_rads'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "token": Provider.of<UserModel>(context, listen: false).token,
        "partner_id": Provider.of<UserModel>(context, listen: false).partnerId,
        "app_id": appId
      }),
    );
    int responseStatus = json.decode(response.body)['result']['status'];
    List<Radiology> radList = [];
    if (responseStatus == 200) {
      for (var index in json.decode(response.body)['result']['message']) {
        print(radList);
        radList.add(Radiology.fromJson(index));
      }
      return radList.reversed.toList();
    } else {
      throw Exception('Errrr Failed to get radiology');
    }
  }

  static Future<int> createRadRequest(BuildContext context, String results, int appId, String name) async {
    http.Response response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/techclinic/mob_create_rad'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          'partner_id':
          Provider.of<UserModel>(context, listen: false).partnerId,
          'token':
          Provider.of<UserModel>(context, listen: false).token,
          'scan_type': name,
          'image': results,
          'app_id': appId
        },
      ),
    );
    print(response.body);
    int responseStatus = json.decode(response.body)['result']['status'];
    if (responseStatus != 200) {
      throw Exception('Error Failed to create request');
    }
    return responseStatus;
  }

  static Future<int> AddRadResults(BuildContext context, String image, String name, int radId) async {
    http.Response response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/techclinic/mob_create_rad'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          'partner_id':
          Provider.of<UserModel>(context, listen: false).partnerId,
          'token':
          Provider.of<UserModel>(context, listen: false).token,
          'rad_id': radId,
          'image': image,
          'scan_type': name
        },
      ),
    );
    print(response.body);
    int responseStatus = json.decode(response.body)['result']['status'];
    if (responseStatus != 200) {
      throw Exception('Error Failed to post picture');
    }
    return responseStatus;
  }
}