import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medic_app/model/gallery_model.dart';
import 'package:medic_app/model/lab_model.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/base_api.dart';
import 'package:provider/provider.dart';

class LabApi extends BaseApiManagement {
  static Future<List<Lab>> getLabs(
      BuildContext context, int appId) async {
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/techclinic/mob_get_labs'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "token": Provider.of<UserModel>(context, listen: false).token,
        "partner_id": Provider.of<UserModel>(context, listen: false).partnerId,
        "app_id": appId
      }),
    );
    print(response.body);
    int responseStatus = json.decode(response.body)['result']['status'];
    List<Lab> labList = [];
    if (responseStatus == 200) {
      for (var index in json.decode(response.body)['result']['message']) {
        if (index['name'] == false || index['date'] == false) {
          continue;
        }
        labList.add(Lab.fromJson(index));
      }
      return labList;
    } else {
      throw Exception('Errrr Failed to get services');
    }
  }

  static Future<int> postLab(BuildContext context, List measures, List results, List units, String name, int appId, DateTime date) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    http.Response response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/techclinic/mob_create_lab'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          'partner_id':
          Provider.of<UserModel>(context, listen: false).partnerId,
          'token':
          Provider.of<UserModel>(context, listen: false).token,
          'name': name,
          'results': results,
          'measures': measures,
          'units': units,
          'app_id': appId,
          'date': formattedDate
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

  static Future<int> postLabImage(BuildContext context, String image, String name, int appId, DateTime date) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    http.Response response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/techclinic/mob_create_lab'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          'partner_id':
          Provider.of<UserModel>(context, listen: false).partnerId,
          'token':
          Provider.of<UserModel>(context, listen: false).token,
          'image': image,
          'name': name,
          'app_id': appId,
          'date': formattedDate
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
