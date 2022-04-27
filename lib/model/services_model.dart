import 'dart:ffi';

import 'package:flutter/cupertino.dart';

class ServicesModel {
  int? id;
  String? name;
  dynamic specialtyId;
  dynamic doctorId;
  double? price;
  String? serviceClass;

  ServicesModel({
    this.id,
    this.name,
    this.specialtyId,
    this.doctorId,
    this.price,
    this.serviceClass,
  });

  factory ServicesModel.fromJson(Map<String, dynamic> json) {
    return ServicesModel(
        id: json['id'],
        name: json['name'],
        specialtyId: json['specialty_id'],
        doctorId: json['doctor_id'],
        price: json['price'],
        serviceClass: json['service_class']
    );
  }
}

class ServicesList extends ChangeNotifier {
  List<ServicesModel> _servicesList = [];


  set services(List<ServicesModel> newList) {
    _servicesList = newList;
    notifyListeners();
  }

  List<ServicesModel> get services => _servicesList;
}
