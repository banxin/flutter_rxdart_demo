import 'package:flutter/material.dart';

class UserInfo {
  String nickname;
  int level;
  String imageURL;

  UserInfo(this.nickname, this.level, this.imageURL);
}

class UserViewModel extends ChangeNotifier {
  UserInfo _user;

  UserViewModel(this._user);

  UserInfo get user => _user;

  set user(UserInfo value) {
    _user = value;
    notifyListeners();
  }
}
