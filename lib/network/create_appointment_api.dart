import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/base_api.dart';
import 'package:provider/provider.dart';

class CreateAppointmentApi extends BaseApiManagement {
  static Future<int> createAppointment(
      BuildContext context, DateTime date, int doctorId, int partnerId, int typeId, int timeId, dynamic doctorName, int clinicId) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    String dayName = DateFormat('EEEE').format(date);

    var body = {
      'partner_id': partnerId,
      'type': typeId,
      'date': formattedDate,
      'doctor': doctorId,
      'day': dayName,
      'time': timeId,
      "token": Provider.of<UserModel>(context, listen: false).token,
      'doctor_name': doctorName,
      'clinic_id': clinicId

    };
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/techclinic/mob_create_appointment'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    int responseStatus = json.decode(response.body)['result']['status'];
    if (responseStatus != 200) {
      throw Exception('Error Failed to request a service');
    }
    return responseStatus;
  }
}
