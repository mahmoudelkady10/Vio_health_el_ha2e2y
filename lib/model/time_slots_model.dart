import 'package:flutter/cupertino.dart';

class TimesModel {
  int? id;
  String? dayName;
  String? time;

  TimesModel({
    this.id,
    this.dayName,
    this.time,
  });

  factory TimesModel.fromJson(Map<String, dynamic> json) {
    return TimesModel(
      id: json['id'],
      dayName: json['day'],
      time: json['time'],
    );
  }
}

class TimesList extends ChangeNotifier {
  List<TimesModel> _timesList = [];


  set times(List<TimesModel> newList) {
    _timesList = newList;
    notifyListeners();
  }

  List<TimesModel> get times => _timesList;
}
