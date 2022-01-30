import 'package:flutter/cupertino.dart';

class DoctorsModel {
  int? id;
  int? specialtyId;
  String? title;
  String? specialty;
  String? name;
  String? imageUrl;
  String? description;
  String? level;

  DoctorsModel({
    this.id,
    this.specialtyId,
    this.title,
    this.specialty,
    this.name,
    this.imageUrl,
    this.description,
    this.level
  });

  factory DoctorsModel.fromJson(Map<String, dynamic> json) {
    return DoctorsModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image'],
      specialtyId: json['specialty_id'],
      specialty: json['specialty'],
      title: json['title'],
      level: json['level']
    );
  }
}

class DoctorsList extends ChangeNotifier {
  List<DoctorsModel> _doctorsList = [];


  set doctors(List<DoctorsModel> newList) {
    _doctorsList = newList;
    notifyListeners();
  }

  List<DoctorsModel> get doctors => _doctorsList;
}
