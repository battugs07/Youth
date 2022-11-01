import 'package:dio/dio.dart';
import 'package:youth/core/models/user.dart';
import 'package:lambda/modules/network_util.dart';

import '../../locator.dart';
import 'api.dart';

class UserService {
  NetworkUtil _http = new NetworkUtil();
  Api api = locator<Api>();

  Future<void> updateUser(User user, MultipartFile avatar) async {
    await _http.post(
      '/api/m/update/profile/${user.id}',
      {
        "avatar": avatar.toString(),
        //"nickname": user.nickname,
        "phone": user.phone,
        "gender": user.gender,
        "age": user.age,
      },
    );
  }
}
