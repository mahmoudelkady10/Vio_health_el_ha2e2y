import 'package:flutter/cupertino.dart';

class HmModel {
  dynamic category;
  dynamic bgMeasure;
  dynamic systolicPressure;
  dynamic diastolicPressure;
  dynamic heartRate;
  dynamic bodyTemp;
  dynamic rrMax;
  dynamic rrMin;
  dynamic hrv;
  dynamic mood;
  dynamic durationEcg;
  dynamic spo2;
  dynamic date;
  dynamic respiratoryRate;
  dynamic ecgWave;

  HmModel({
    this.category,
    this.systolicPressure,
    this.bodyTemp,
    this.diastolicPressure,
    this.bgMeasure,
    this.date,
    this.durationEcg,
    this.heartRate,
    this.hrv,
    this.mood,
    this.rrMax,
    this.rrMin,
    this.spo2,
    this.respiratoryRate,
    this.ecgWave
  });

  factory HmModel.fromJson(Map<String, dynamic> json) {
    return HmModel(
        category: json['category'],
        bgMeasure: json['bg_measure'],
        systolicPressure: json['systolic_pressure'],
        diastolicPressure: json['diastolic_pressure'],
        heartRate: json['heart_rate'],
        bodyTemp: json['body_temp'],
        rrMax: json['rrmax'],
        rrMin: json['rrmin'],
        hrv: json['hrv'],
        mood: json['mood'],
        durationEcg: json['duration_ecg'],
        spo2: json['spo2'],
        date: json['date_stamp'],
        respiratoryRate: json['respiratory_rate'],
        ecgWave: json['ecg_wave']
    );
  }
}

class HmDataList extends ChangeNotifier {
  List<HmModel> _hmDataList = [];

  set hmData(List<HmModel> newList) {
    _hmDataList = newList;
    notifyListeners();
  }

  List<HmModel> get hmData => _hmDataList;
}
