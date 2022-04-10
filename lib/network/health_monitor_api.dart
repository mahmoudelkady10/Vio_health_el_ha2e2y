import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medic_app/model/health_monitor_model.dart';
import 'base_api.dart';

class HmApi extends BaseApiManagement {
  static Future<http.Response> postReadings(dynamic data) async {
    var jsonBody = data;

    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/mob_hm_upload'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(jsonBody),
    );
    print(response.body);
    return response;
  }
  static Future<List<HmModel>> getReadings(BuildContext context, int? userId, String? token) async {
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/mob_hm_download'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"partner_id": userId,
        "token": token
      }),
    );
    print(response.body);
    int responseStatus = json.decode(response.body)['result']['status'];
    List<HmModel> hmDataList = [];
    if (responseStatus == 200) {
      for (var index in json.decode(response.body)['result']['data']) {

        hmDataList.add(HmModel.fromJson(index));
      }
      return hmDataList.reversed.toList();
    } else {
      throw Exception('Errrr Failed to get appointments');
    }
  }
}


// if (json.decode(response.body)['result']['data']['user_type'] == 'employee') {
//   e7def 3ala employee model
// } else if (json.decode(response.body)['result']['data']['user_type'] == 'customer'){
//   e7def 3ala user model
// }