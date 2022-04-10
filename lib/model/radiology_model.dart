import 'package:flutter/cupertino.dart';

class Radiology {
  dynamic id;
  dynamic name;
  dynamic date;
  List<RadiologyLines>? radLines;

  Radiology({
    this.id,
    this.name,
    this.date,
    this.radLines,
  });

  factory Radiology.fromJson(Map<String, dynamic> json) {
    List<RadiologyLines>? tempList = [];

    for (var index in json['results']) {
      if (index['name'] == false){
        continue;
      }
      tempList.add(RadiologyLines.fromJson(index));
    }

    return Radiology(
        id: json['id'],
        name: json['name'],
        date: json['date'],
        radLines: tempList,
    );
  }
}

class RadiologyList extends ChangeNotifier {
  List<RadiologyList> _radiologyList = [];

  set radiology(List<RadiologyList> newList) {
    _radiologyList = newList;
    notifyListeners();
  }

  List<RadiologyList> get radiology => _radiologyList;
}

class RadiologyLines {
  String? name;
  String? image;
  dynamic comment;


  RadiologyLines({this.name, this.image, this.comment});

  factory RadiologyLines.fromJson(Map<String, dynamic> json) {
    return RadiologyLines(
        name: json['name'],
        image: json['image'],
        comment: json['comment']
    );
  }
}
