import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medic_app/model/time_slots_model.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/base_api.dart';
import 'package:provider/provider.dart';

class TimesApi extends BaseApiManagement {
  static Future<List<TimesModel>> getTimeSlots(
      BuildContext context, DateTime date, int doctorId) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    String dayName = DateFormat('EEEE').format(date);
    print(dayName);
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/mob_get_time_slots'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "doctor_id": doctorId,
        "date": formattedDate,
        "day": dayName,
        "token": Provider.of<UserModel>(context, listen: false).token
      }),
    );
    print(response.body);
    int responseStatus = json.decode(response.body)['result']['status'];
    List<TimesModel> timesList = [];
    if (responseStatus == 200) {
      for (var index in json.decode(response.body)['result']['data']) {
        timesList.add(TimesModel.fromJson(index));
      }
      Provider.of<TimesList>(context, listen: false).times =
          timesList;
      return timesList;
    } else {
      throw Exception('Errrr Failed to get time slots');
    }
  }
}
