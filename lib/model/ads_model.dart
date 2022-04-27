import 'package:flutter/cupertino.dart';

class AdsModel {
  String? image;


  AdsModel({
    this.image,
  });

  factory AdsModel.fromJson(Map<String, dynamic> json) {
    return AdsModel(
      image: json['image']
    );
  }
}

class AdsList extends ChangeNotifier {
  List<AdsModel> _adsList = [];


  set ads(List<AdsModel> newList) {
    _adsList = newList;
    notifyListeners();
  }

  List<AdsModel> get ads => _adsList;
}
