import 'package:flutter/cupertino.dart';

class FollowUpModel {
  dynamic name;
  dynamic image;
  dynamic categoryId;

  FollowUpModel({this.name, this.image, this.categoryId});

  factory FollowUpModel.fromJson(Map<String, dynamic> json) {
    return FollowUpModel(
        name: json['name'],
        image: json['image'],
        categoryId: json['id']

    );
  }
}

class FollowUpList extends ChangeNotifier {
  List<FollowUpModel> _followUpList = [];

  set followUp(List<FollowUpModel> newList) {
    _followUpList = newList;
    notifyListeners();
  }

  List<FollowUpModel> get followUp => _followUpList;
}

class FollowUpSubCategoriesModel {
  dynamic name;
  dynamic subCategoryId;
  dynamic type;
  dynamic operator;

  FollowUpSubCategoriesModel({this.name, this.subCategoryId, this.type, this.operator});

  factory FollowUpSubCategoriesModel.fromJson(Map<String, dynamic> json) {
    return FollowUpSubCategoriesModel(
        name: json['name'],
        subCategoryId: json['id'],
        type: json['type'],
        operator: json['operator']

    );
  }
}

class FollowUpSubCategoriesList extends ChangeNotifier {
  List<FollowUpSubCategoriesModel> _followUpSubCategoriesList = [];

  set followUpSubCategories(List<FollowUpSubCategoriesModel> newList) {
    _followUpSubCategoriesList = newList;
    notifyListeners();
  }

  List<FollowUpSubCategoriesModel> get followUpSubCategories => _followUpSubCategoriesList;
}

class FollowUpReadingsModel {
  dynamic category;
  dynamic sub_category;
  dynamic type;
  dynamic readings;
  dynamic date;

  FollowUpReadingsModel({this.category,this.sub_category,this.readings,this.date, this.type});

  factory FollowUpReadingsModel.fromJson(Map<String, dynamic> json) {
    return FollowUpReadingsModel(
        category: json['category'],
        sub_category: json['sub_category'],
        readings: json['readings'],
        date: json['date'],
        type: json['type']
    );
  }
}

class FollowUpReadingsList extends ChangeNotifier {
  List<FollowUpReadingsModel> _followUpReadingsList = [];

  set followUpReadings(List<FollowUpReadingsModel> newList) {
    _followUpReadingsList = newList;
    notifyListeners();
  }

  List<FollowUpReadingsModel> get followUpReadings => _followUpReadingsList;
}