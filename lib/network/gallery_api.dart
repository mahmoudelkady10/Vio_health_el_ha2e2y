import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medic_app/model/gallery_model.dart';
import 'package:medic_app/model/user_model.dart';
import 'package:medic_app/network/base_api.dart';
import 'package:provider/provider.dart';

class GalleryApi extends BaseApiManagement {
  static Future<List<GalleryModel>> getGallery(
      BuildContext context, int appId) async {
    var response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/mob_get_attachments'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "appointment_id": appId,
        "token": Provider.of<UserModel>(context, listen: false).token
      }),
    );
    print(response.body);
    int responseStatus = json.decode(response.body)['result']['status'];
    List<GalleryModel> galleryList = [];
    if (responseStatus == 200) {
      for (var index in json.decode(response.body)['result']['data']) {
        if (index['specialty_id'] == false || index['visit_date'] == false) {
          continue;
        }
        galleryList.add(GalleryModel.fromJson(index));
      }
      return galleryList;
    } else {
      throw Exception('Errrr Failed to get services');
    }
  }

  static Future<int> postGallery(BuildContext context, String image,
      DateTime date, String comment, int appId, int doctorId) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    http.Response response = await http.post(
      Uri.parse('${BaseApiManagement.baseUrl}/vio/mob_post_attachments'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          'partner_id':
              Provider.of<UserModel>(context, listen: false).partnerId,
          'token':
          Provider.of<UserModel>(context, listen: false).token,
          'date': formattedDate,
          'appointment_id': appId,
          'doctor_id': doctorId,
          'comment': comment,
          'image': image
        },
      ),
    );
    print(response.body);
    int responseStatus = json.decode(response.body)['result']['status'];
    if (responseStatus != 200) {
      throw Exception('Error Failed to post picture');
    }
    return responseStatus;
  }
}
