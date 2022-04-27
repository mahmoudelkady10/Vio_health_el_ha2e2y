import 'package:flutter/cupertino.dart';

class SpecialtiesModel {
  int? id;
  dynamic name;
  dynamic imageUrl;
  dynamic description;
  dynamic extras;

  SpecialtiesModel({
    this.id,
    this.name,
    this.imageUrl,
    this.description,
    this.extras
  });

  factory SpecialtiesModel.fromJson(Map<String, dynamic> json) {
    return SpecialtiesModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      extras: json['extra_info'],
      imageUrl: json['image'],
    );
  }
}

class SpecialtiesList extends ChangeNotifier {
  List<SpecialtiesModel> _specialtiesList = [];


  set specialties(List<SpecialtiesModel> newList) {
    _specialtiesList = newList;
    notifyListeners();
  }

  List<SpecialtiesModel> get specialties => _specialtiesList;
}
