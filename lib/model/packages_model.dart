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
