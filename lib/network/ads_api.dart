import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medic_app/model/ads_model.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/base_api.dart';
import 'package:provider/provider.dart';


class AdsApi extends BaseApiManagement {
  static Future<List<AdsModel>> getAds(BuildContext context) async {
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/techclinic/mob_get_ads'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "token": Provider
            .of<UserModel>(context, listen: false)
            .token
      }),
    );
    print(response.body);
    int responseStatus = json.decode(response.body)['result']['status'];
    List<AdsModel> adsList = [];
    if (responseStatus == 200) {
      for (var index in json.decode(response.body)['result']['message']) {
        adsList.add(AdsModel.fromJson(index));
      }
      return adsList;
    } else {
      throw Exception('Errrr Failed to get ads');
    }
  }
}