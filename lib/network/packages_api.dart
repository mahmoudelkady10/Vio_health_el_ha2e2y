import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medic_app/model/packages_model.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/base_api.dart';
import 'package:provider/provider.dart';

class PackagesApi extends BaseApiManagement {
  static Future<List<PackagesModel>> getPackages(BuildContext context) async {
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/patientpackage'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "params": {
          "token": Provider.of<UserModel>(context, listen: false).token,
          "uid": Provider.of<UserModel>(context, listen: false).uid,
        }
      }),
    );
    print(response.body);
    int responseStatus = json.decode(response.body)['result']['status'];
    List<PackagesModel> packagesList = [];
    if (responseStatus == 200) {
      for (var index in json.decode(response.body)['result']['package_list']) {
        packagesList.add(PackagesModel.fromJson(index));
      }
      print(packagesList.length);
      return packagesList;
    } else {
      throw Exception('Errrr Failed to get packages');
    }
  }

  static Future<List<PackagesContentModel>> getPackagesContent(
      BuildContext context, int packageId) async {
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/patientpackaschedule'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "params": {
          "token": Provider.of<UserModel>(context, listen: false).token,
          "uid": Provider.of<UserModel>(context, listen: false).uid,
          "package_id": packageId,
        }
      }),
    );
    print(response.body);
    int responseStatus = json.decode(response.body)['result']['status'];
    List<PackagesContentModel> packagesContentList = [];
    if (responseStatus == 200) {
      for (var index in json.decode(response.body)['result']
          ['package_schedule']) {
        packagesContentList.add(PackagesContentModel.fromJson(index));
      }
      Provider.of<PackagesContentList>(context, listen: false).packagesContent = packagesContentList;
      return packagesContentList;
    } else {
      throw Exception('Errrr Failed to get packages');
    }
  }

  static Future<List<NewPackagesModel>> availablePackages(BuildContext context) async {
    print(Provider.of<UserModel>(context, listen: false).medicalId);
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/servicelist'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "params": {
          // "token": Provider.of<UserModel>(context, listen: false).token,
          "uid": Provider.of<UserModel>(context, listen: false).uid,
          "medical_id": Provider.of<UserModel>(context, listen: false).medicalId,
        }
      }),
    );
    print(json.decode(response.body)['result']['payment_methods']);
    int responseStatus = json.decode(response.body)['result']['status'];
    List<NewPackagesModel> packagesList = [];
    if (responseStatus == 200) {
      for (var index in json.decode(response.body)['result']['service_list']) {
        if (index['service_type'] != 'package'){
          continue;
        }
        packagesList.add(NewPackagesModel.fromJson(index));
      }
      print(packagesList.length);
      return packagesList;
    } else {
      throw Exception('Errrr Failed to get packages');
    }
  }
}
