import 'package:flutter/cupertino.dart';

class UserModel extends ChangeNotifier {
  dynamic partnerId_;
  dynamic name_;
  dynamic image_;
  dynamic email_;
  dynamic bloodGroup_;
  dynamic weight_;
  dynamic gender_;
  dynamic medicalId_;
  dynamic uid_;
  dynamic userType_;
  dynamic token_;
  dynamic balance_;
  dynamic onHold_;


  /// Setter and getters for fields
  /// User related fields
  set balance(dynamic name) {
    balance_ = name;
    notifyListeners();
  }

  dynamic get balance => balance_;

  set onHold(dynamic name) {
    onHold_ = name;
    notifyListeners();
  }

  dynamic get onHold => onHold_;

  set partnerId(dynamic id) {
    partnerId_ = id;
    notifyListeners();
  }

  dynamic get partnerId => partnerId_;

  set name(dynamic name) {
    name_ = name;
    notifyListeners();
  }

  dynamic get name => name_;

  set image(dynamic image) {
    image_ = image;
    notifyListeners();
  }

  dynamic get image => image_;

  set email(dynamic name) {
    email_ = name;
    notifyListeners();
  }

  dynamic get email => email_;

  set bloodGroup(dynamic name) {
    bloodGroup_ = name;
    notifyListeners();
  }

  dynamic get bloodGroup => bloodGroup_;

  set weight(dynamic name) {
    weight_ = name;
    notifyListeners();
  }

  dynamic get weight => weight_;

  set gender(dynamic name) {
    gender_ = name;
    notifyListeners();
  }

  dynamic get gender => gender_;

  set medicalId(dynamic name) {
    medicalId_ = name;
    notifyListeners();
  }

  dynamic get medicalId => medicalId_;

  set uid(dynamic name) {
    uid_ = name;
    notifyListeners();
  }

  dynamic get uid => uid_;

  set userType(dynamic name) {
    userType_ = name;
    notifyListeners();
  }

  dynamic get userType => userType_;

  set token(dynamic name) {
    token_ = name;
    notifyListeners();
  }

  dynamic get token => token_;


  void loginSetting(UserModel user) {
    partnerId = user.partnerId_;
    name = user.name_;
    image = user.image_;
    email = user.email_;
    bloodGroup = user.bloodGroup_;
    weight = user.weight_;
    gender = user.gender_;
    medicalId = user.medicalId_;
    uid = user.uid_;
    userType = user.userType_;
    token = user.token_;
    balance = user.balance_;
    onHold = user.onHold_;
  }

  UserModel({
    this.partnerId_,
    this.name_,
    this.image_,
    this.email_,
    this.gender_,
    this.bloodGroup_,
    this.weight_,
    this.medicalId_,
    this.uid_,
    this.userType_,
    this.token_,
    this.balance_,
    this.onHold_,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      partnerId_: json['partner_id'],
      uid_: json['uid'],
      medicalId_: json['medical_id'],
      name_: json['name'],
      image_: json['image'],
      email_: json['email'],
      userType_: json['user_type'],
      bloodGroup_: json['blood_group'],
      weight_: json['weight'],
      gender_: json['gender'],
      token_: json['token'],
      balance_: json['wallet_balance'],
      onHold_: json['wallet_hold'],

    );
  }
}
