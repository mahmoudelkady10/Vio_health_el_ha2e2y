import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medic_app/model/appointments_model.dart';
import 'package:medic_app/network/base_api.dart';

class AppointmentsApi extends BaseApiManagement {
  static Future<List<AppointmentsModel>> getAppointments(BuildContext context, int? userId, String? token) async {
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/mob_appointments'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"partner_id": userId,
                        "token": token
      }),
    );
    print(response.body);
    int responseStatus = json.decode(response.body)['result']['status'];
    List<AppointmentsModel> appointmentsList = [];
    if (responseStatus == 200) {
      for (var index in json.decode(response.body)['result']['data']) {

        appointmentsList.add(AppointmentsModel.fromJson(index));
      }
      return appointmentsList;
    } else {
      throw Exception('Errrr Failed to get appointments');
    }
  }
}
