import 'package:flutter/cupertino.dart';

class GalleryModel {
  int? id;
  String? doctor;
  String? date;
  String? comment;
  String? image;


  GalleryModel({
    this.id,
    this.doctor,
    this.date,
    this.comment,
    this.image
  });

  factory GalleryModel.fromJson(Map<String, dynamic> json) {
    return GalleryModel(
      id: json['id'],
      doctor: json['doctor'],
      date: json['date'],
      comment: json['comment'],
      image: json['image']
    );
  }
}

class GalleryList extends ChangeNotifier {
  List<GalleryModel> _galleryList = [];


  set gallery(List<GalleryModel> newList) {
    _galleryList = newList;
    notifyListeners();
  }

  List<GalleryModel> get gallery => _galleryList;
}
