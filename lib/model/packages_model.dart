import 'package:flutter/cupertino.dart';

class PackagesModel {
  int? id;
  String? name;
  String? packageId;
  String? startDate;
  double? price;
  String? state;

  PackagesModel({
    this.id,
    this.name,
    this.packageId,
    this.startDate,
    this.price,
    this.state,
  });

  factory PackagesModel.fromJson(Map<String, dynamic> json) {
    return PackagesModel(
      id: json['package_id'],
      name: json['name'],
      packageId: json['package_name'],
      startDate: json['start_date'],
      price: json['package_price'],
      state: json['state']
    );
  }
}

class PackagesList extends ChangeNotifier {
  List<PackagesModel> _packagesList = [];


  set packages(List<PackagesModel> newList) {
    _packagesList = newList;
    notifyListeners();
  }

  List<PackagesModel> get packages => _packagesList;
}


class PackagesContentModel {
  dynamic name;
  dynamic specialty;
  dynamic service;
  dynamic packageId;
  dynamic startDate;
  dynamic productQty;
  dynamic productRem;

  PackagesContentModel({
    this.name,
    this.specialty,
    this.service,
    this.packageId,
    this.startDate,
    this.productQty,
    this.productRem
  });



  factory PackagesContentModel.fromJson(Map<String, dynamic> json) {
    return PackagesContentModel(
        packageId: json['package_id'],
        startDate: json['start_date'],
        specialty: json['specialty'],
        service: json['service'],
        productQty: json['product_qty'],
        productRem: json['product_remain_qty']
    );
  }
}

class PackagesContentList extends ChangeNotifier {
  List<PackagesContentModel> _packagesContentList = [];


  set packagesContent(List<PackagesContentModel> newList) {
    _packagesContentList = newList;
    notifyListeners();
  }

  List<PackagesContentModel> get packagesContent => _packagesContentList;
}

class NewPackagesModel {
  int? id;
  String? name;
  String? mainCategory;
  double? price;

  NewPackagesModel({
    this.id,
    this.name,
    this.mainCategory,
    this.price,
  });

  factory NewPackagesModel.fromJson(Map<String, dynamic> json) {
    return NewPackagesModel(
        id: json['id'],
        name: json['name'],
        mainCategory: json['main_category'],
        price: json['service_price'],
    );
  }
}

class NewPackagesList extends ChangeNotifier {
  List<NewPackagesModel> _packagesList = [];


  set packages(List<NewPackagesModel> newList) {
    _packagesList = newList;
    notifyListeners();
  }

  List<NewPackagesModel> get packages => _packagesList;
}
