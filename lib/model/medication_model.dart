import 'package:flutter/cupertino.dart';

class MedicationModel {
  dynamic medicineId;
  dynamic medicineFormId;
  dynamic dosageQuantity;
  dynamic frequency;
  dynamic days;
  dynamic image;

  MedicationModel(
      {this.medicineId,
      this.medicineFormId,
      this.dosageQuantity,
      this.frequency,
      this.days,
      this.image});

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      medicineId: json['name'],
      medicineFormId: json['form'],
      dosageQuantity: json['quantity'],
      frequency: json['frequency'],
      days: json['days'],
      image: json['image'],
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
