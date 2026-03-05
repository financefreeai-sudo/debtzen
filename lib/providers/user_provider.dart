import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class UserProvider extends ChangeNotifier {
  UserProfile _user = UserProfile();

  UserProfile get user => _user;

  void setName(String name) {
    _user.name = name;
    notifyListeners();
  }
}
