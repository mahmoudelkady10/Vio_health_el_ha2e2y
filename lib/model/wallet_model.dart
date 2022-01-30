import 'package:flutter/cupertino.dart';

class WalletModel extends ChangeNotifier {
  int? balance_;
  int? onHold_;


  WalletModel({
    this.balance_,
    this.onHold_,
  });

  factory WalletModel.fromJson(Map<String, int?> json) {
    return WalletModel(
        balance_: json['balance'],
        onHold_: json['onHold'],
    );
  }

  set balance(int? name) {
    balance_ = name;
    notifyListeners();
  }

  int? get balance => balance_;

  set onHold(int? name) {
    onHold_ = name;
    notifyListeners();
  }

  int? get onHold => onHold_;


  void walletSettings(WalletModel user) {
    balance = user.balance_;
    onHold = user.onHold_;
  }
}

