import 'package:flutter/cupertino.dart';

class CityModel {
  dynamic name;

  CityModel({
    this.name,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
        name: json['name']);
  }
}

class CityList extends ChangeNotifier {
  List<CityModel> _cityList = [];

  set city(List<CityModel> newList) {
    _cityList = newList;
    notifyListeners();
  }

  List<CityModel> get city => _cityList;
}
