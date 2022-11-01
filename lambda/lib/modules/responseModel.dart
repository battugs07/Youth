class ResponseModel {
  bool _status = false;
  String _msg = '';
  dynamic _data;

  ResponseModel.fromJson(Map<String, dynamic> parsedJson) {
    _status = parsedJson['status'];
    _msg = parsedJson['msg'];
    _data = parsedJson['data'];
  }

  ResponseModel.fromError() {
    _status = false;
    _msg = 'Алдаа гарлаа';
    _data = null;
  }

  bool get status => _status;

  String get msg => _msg;

  dynamic get data => _data;
}
