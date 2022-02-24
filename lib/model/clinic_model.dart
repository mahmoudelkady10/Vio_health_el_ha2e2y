import 'package:flutter/cupertino.dart';

class ClinicModel {
  int? id;
  String? name;

  ClinicModel({
    this.id,
    this.name,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class ClinicList extends ChangeNotifier {
  List<ClinicModel> _clinicList = [];


  set clinics(List<ClinicModel> newList) {
    _clinicList = newList;
    notifyListeners();
  }

  List<ClinicModel> get clinics => _clinicList;
}
