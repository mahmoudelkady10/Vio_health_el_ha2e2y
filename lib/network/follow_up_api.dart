import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medic_app/model/follow_up_model.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/base_api.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class FollowUpApi extends BaseApiManagement {
  static Future<List<FollowUpModel>> getCategories(BuildContext context) async {
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/mob_get_categories'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "partner_id": Provider.of<UserModel>(context).uid,
        "token": Provider.of<UserModel>(context, listen: false).token
      }),
    );
    print(response.body);
    int responseStatus = json.decode(response.body)['result']['status'];
    List<FollowUpModel> followUpList = [];
    if (responseStatus == 200) {
      for (var index in json.decode(response.body)['result']['message']) {
        followUpList.add(FollowUpModel.fromJson(index));
      }
      print(followUpList);
      return followUpList;
    } else {
      throw Exception('Error Failed to get categories');
    }
  }

  static Future<List<FollowUpSubCategoriesModel>> getSubCategories(
      BuildContext context, dynamic categoryId) async {
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/mob_get_sub_categories'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "partner_id": Provider.of<UserModel>(context).uid,
        "token": Provider.of<UserModel>(context, listen: false).token,
        "categoryId": categoryId
      }),
    );
    print(response.body);
    int responseStatus = json.decode(response.body)['result']['status'];
    List<FollowUpSubCategoriesModel> followUpSubCategoriesList = [];
    if (responseStatus == 200) {
      for (var index in json.decode(response.body)['result']['message']) {
        followUpSubCategoriesList
            .add(FollowUpSubCategoriesModel.fromJson(index));
      }
      print(followUpSubCategoriesList);
      return followUpSubCategoriesList;
    } else {
      throw Exception('Error Failed to get sub categories');
    }
  }

  static Future<int> postReadings(
      BuildContext context, dynamic category, dynamic sub_category, dynamic readings, DateTime sDate) async {
    String formattedDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(sDate);
    http.Response response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/mob_get_sub_categories'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          'category': category,
          'sub_category': sub_category,
          'readings': readings,
          'partner_id': Provider.of<UserModel>(context, listen: false).partnerId.toString(),
          'medical_id': Provider.of<UserModel>(context, listen: false)
              .medicalId
              .toString(),
          'date': formattedDate,
          "token": Provider.of<UserModel>(context, listen: false).token
        },
      ),
    );
    print(response.body);
    int responseStatus = json.decode(response.body)['result']['message'];
    if (responseStatus != 200) {
      throw Exception('Error to post readings');
    }
    return responseStatus;
  }

  static Future<List<FollowUpReadingsModel>> getReadings(BuildContext context, dynamic categoryId) async {
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/mob_get_readings'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "partner_id": Provider.of<UserModel>(context).uid,
        "token": Provider.of<UserModel>(context, listen: false).token,
        "category_id": categoryId
      }),
    );
    print(response.body);
    int responseStatus = json.decode(response.body)['result']['status'];
    List<FollowUpReadingsModel> followUpReadingsList = [];
    if (responseStatus == 200) {
      for (var index in json.decode(response.body)['result']['message']) {
        followUpReadingsList.add(FollowUpReadingsModel.fromJson(index));
      }
      print(followUpReadingsList);
      return followUpReadingsList;
    } else {
      throw Exception('Error Failed to get readings');
    }
  }
}
