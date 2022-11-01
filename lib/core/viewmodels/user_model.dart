import 'package:youth/core/services/user_service.dart';

import '../../locator.dart';
import '../models/user.dart';
import 'base_model.dart';

class UserModel extends BaseModel {
  UserService api = locator<UserService>();
  UserModel();

  User? _user;

  void setUser(User data) {
    _user = data;
    notifyListeners();
  }

  User? get getUser => _user;
}
