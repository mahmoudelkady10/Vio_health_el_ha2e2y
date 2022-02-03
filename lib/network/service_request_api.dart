import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/base_api.dart';
import 'package:provider/provider.dart';

class ServiceRequestApi extends BaseApiManagement {
  static Future<int> serviceRequest(
      BuildContext context,
      DateTime date,
      bool installment,
      List serviceId,
      int paymentMethod,
      String mainCategory) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    String dayName = DateFormat('EEEE').format(date);

    var body = {
      "params": {
        'service_id': serviceId,
        'payment_method_id': paymentMethod,
        'due_date': formattedDate,
        'main_category': mainCategory,
        'installment': installment,
        "token": Provider.of<UserModel>(context, listen: false).token,
        "uid": Provider.of<UserModel>(context, listen: false).uid,
        "medical_id": Provider.of<UserModel>(context, listen: false).medicalId,
      }
    };
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/requestcreate'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    print(response.body);
    int responseStatus = json.decode(response.body)['result']['status'];
    if (responseStatus != 200) {
      throw Exception('Error Failed to request a service');
    }
    return responseStatus;
  }
}
