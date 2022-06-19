import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/base_api.dart';
import 'package:provider/provider.dart';

class DeleteApi extends BaseApiManagement {
  static Future<dynamic> deleteAcc(BuildContext context) async {
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/mob_delete_user'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {"token": Provider.of<UserModel>(context, listen: false).token}),
    );
    print(response.body);
    int responseStatus = json.decode(response.body)['result']['status'];
    return responseStatus;
  }
}
