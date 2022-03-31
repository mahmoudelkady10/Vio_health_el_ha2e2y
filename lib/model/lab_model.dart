import 'package:flutter/cupertino.dart';

class Lab {
  dynamic id;
  dynamic name;
  dynamic date;
  dynamic image;

  List<LabLines>? labLines;

  Lab({
    this.id,
    this.name,
    this.date,
    this.labLines,
    this.image
  });

  factory Lab.fromJson(Map<String, dynamic> json) {
    List<LabLines>? tempList = [];

    for (var index in json['results']) {
      if (index['measure'] == false){
        continue;
      }
      tempList.add(LabLines.fromJson(index));
    }

    return Lab(
      id: json['id'],
      name: json['name'],
      date: json['date'],
      labLines: tempList,
      image: json['image']
    );
  }
}

class LabList extends ChangeNotifier {
  List<LabList> _labList = [];

  set lab(List<LabList> newList) {
    _labList = newList;
    notifyListeners();
  }

  List<LabList> get lab => _labList;
}

class LabLines {
  String? measure;
  String? result;
  String? unit;


  LabLines({this.measure, this.result, this.unit});

  factory LabLines.fromJson(Map<String, dynamic> json) {
    return LabLines(
      measure: json['measure'],
      result: json['result'],
      unit: json['unit']
    );
  }
}
