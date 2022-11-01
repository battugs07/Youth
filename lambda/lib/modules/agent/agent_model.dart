class AgentModel {
  bool _status = false;
  String _msg = '';
  bool _is_remember = false;
  bool _is_bio = false;
  String _bio_type = '';
  String _bio_txt = '';
  String _token = '';
  String? _login;
  String? _password;

  setStatus(bool val) {
    _status = val;
  }

  setMsg(String val) {
    _msg = val;
  }

  setRemember(bool val) {
    _is_remember = val;
  }

  setBio(bool val) {
    _is_bio = val;
  }

  setBioType(String val) {
    _bio_type = val;
  }

  setBioTxt(String val) {
    _bio_txt = val;
  }

  setToken(String val) {
    _token = val;
  }

  setLogin(String val) {
    _login = val;
  }

  setPasword(String val) {
    _password = val;
  }

  bool get status => _status;

  String get msg => _msg;

  bool get is_remember => _is_remember;

  bool get is_bio => _is_bio;

  String get bio_type => _bio_type;

  String get bio_txt => _bio_txt;

  String get token => _token;

  String get login => _login!;

  String get password => _password!;
}
