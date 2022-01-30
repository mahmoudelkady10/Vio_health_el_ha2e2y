import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'base_api.dart';

class WalletApi extends BaseApiManagement {
   static Future<dynamic> topUp(
      BuildContext context, int? uid, String? amount, String? token) async {
    var jsonBody = {
      'amount': amount,
      'token': token,
    };
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/mob_payment'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(jsonBody),
    );
    print(response.body);
    int responseStatus = json.decode(response.body)['result']['status'];
    if (responseStatus != 200) {
      // throw Exception('Error Failed to login!');
      return responseStatus;
    } else {
      String url = json.decode(response.body)['result']['pay_url'];
      return url;
    }
  }

}


// static Future<int> getWallet(
// BuildContext context, int? uid, String? token) async {
// var jsonBody = {
//   'uid': uid,
//   'token': token
// };
// var response = await http.post(
// Uri.parse('${BaseApiManagement.baseUrl}/vio/mob_wallet'),
// headers: {"Content-Type": "application/json"},
// body: jsonEncode(jsonBody),
// );
// int responseStatus = json.decode(response.body)['result']['status'];
// print(response.body);
// if (responseStatus != 200) {
// // throw Exception('Error Failed to login!');
// return responseStatus;
// } else {
// WalletModel user =
// WalletModel.fromJson(json.decode(response.body)['result']['data']);
// Provider.of<WalletModel>(context, listen: false).walletSettings(user);
// return responseStatus;
// }
// }