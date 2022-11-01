import 'dart:io';

class User {
  int? _id;
  String? _surname;
  String? _name;
  String? _phone;
  String? _email;
  bool? _is_active;
  String? _first_name;
  String? _last_name;
  String? _register;
  String? _profile_image;
  String? _facebook;
  String? _google;
  int? _gender;
  String? _bio;
  String? _age;
  String? _avatar;

  int? _point;
  int? _xp;
  int? _spent;
  int? _trans;

  User.fromJson(Map<String, dynamic> parsedJson) {
    _id = parsedJson['id'];
    _id = parsedJson['surname'];
    _name = parsedJson['name'];
    _phone = parsedJson['phone'];
    _email = parsedJson['email'];
    _is_active = parsedJson['is_active'] == 0 ? false : true;
    _first_name = parsedJson['first_name'];
    _last_name = parsedJson['last_name'];
    _register = parsedJson['register'];
    _profile_image = parsedJson['profile_image'];
    _facebook = parsedJson['facebook'].toString();
    _google = parsedJson['google'].toString();
    _gender = parsedJson['gender'] == "0" ? 0 : 1;
    _bio = parsedJson['bio'];
    _age = parsedJson['age'].toString();
    _avatar = parsedJson['avatar'];

    _point = parsedJson['point'] ?? 0;
    _xp = parsedJson['xp'] ?? 0;
    _spent = parsedJson['spent'] ?? 0;
    _trans = parsedJson['trans'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = _id;
    data['surname'] = _surname;
    data['name'] = _name;
    data['phone'] = _phone;
    data['email'] = _email;
    data['is_active'] = _is_active;
    data['first_name'] = _first_name;
    data['last_name'] = _last_name;
    data['profile_image'] = _profile_image;
    data['register'] = _register;
    data['facebook'] = _facebook;
    data['google'] = _google;
    data['gender'] = _gender;
    data['bio'] = _bio;
    data['age'] = _age;
    data['avatar'] = _avatar;

    data['point'] = _point;
    data['xp'] = _xp;
    data['spent'] = _spent;
    data['trans'] = _trans;
    return data;
  }

  int? get id => _id;

  String? get surname => _surname;

  String? get name => _name;

  String? get phone => _phone;

  String? get email => _email;

  bool? get is_active => _is_active;

  String? get first_name => _first_name;

  String? get last_name => _last_name;

  String? get register => _register;

  String? get profile_image => _profile_image;

  String? get facebook => _facebook;

  String? get google => _google;

  String? get bio => _bio;

  int? get gender => _gender;

  String? get age => _age;

  String? get avatar => _avatar;

  int? get point => _point;

  int? get xp => _xp;

  int? get spend => _spent;

  int? get trans => _trans;

  void setPoint(int val) {
    _point = val;
  }

  void setXp(int val) {
    _xp = xp;
  }

  void setSpend(int val) {
    _spent = xp;
  }

  void setTrans(int val) {
    _trans = xp;
  }

  void setImage(File img) {
    _avatar = img.path;
  }

  void setFirstName(String val) {
    _first_name = val;
  }

  void setSurname(String val) {
    _surname = val;
  }

  void setLastName(String val) {
    _last_name = val;
  }

  void setRegister(String val) {
    _register = val;
  }

  void setProfileImage(String val) {
    _profile_image = val;
  }

  void setPhone(String val) {
    _phone = val;
  }

  void setGender(int val) {
    _gender = val;
  }

  void setAge(String val) {
    _age = val;
  }
}
