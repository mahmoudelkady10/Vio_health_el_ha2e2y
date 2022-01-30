import 'package:flutter/cupertino.dart';

class MedicationModel {
  String? medicineId;
  String? medicineFormId;
  String? dosageQuantity;
  String? frequency;
  String? days;

  MedicationModel({
    this.medicineId,
    this.medicineFormId,
    this.dosageQuantity,
    this.frequency,
    this.days,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
        medicineId: json['name'],
        medicineFormId: json['form'],
        dosageQuantity: json['quantity'],
        frequency: json['frequency'],
        days: json['days'],
    );
  }
}

class MedicationList extends ChangeNotifier {
  List<MedicationModel> _medicationList = [];


  set medication(List<MedicationModel> newList) {
    _medicationList = newList;
    notifyListeners();
  }

  List<MedicationModel> get medication => _medicationList;
}
