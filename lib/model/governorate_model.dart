import 'package:flutter/cupertino.dart';

class GovernorateModel {
  dynamic name;

  GovernorateModel({
    this.name,
  });

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    return GovernorateModel(
        name: json['name']);
  }
}

class GovernorateList extends ChangeNotifier {
  List<GovernorateModel> _governorateList = [];

  set governorate(List<GovernorateModel> newList) {
    _governorateList = newList;
    notifyListeners();
  }

  List<GovernorateModel> get governorate => _governorateList;
}
