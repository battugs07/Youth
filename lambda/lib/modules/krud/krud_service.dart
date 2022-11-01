import '../network_util.dart';

class KrudService {
  NetworkUtil _http = new NetworkUtil();

  Future<dynamic> krudList(String url, dynamic model) async {
    var data = [];
    final response = await _http.get(url);
    var parsed = response.chartdata['data'] as List<dynamic>;

    for (var f in parsed) {
//      data.add(new model.fromJson(f));
    }

    return data;
  }

  Future<void>? krudSingle(String url) {
    return null;
  }
}
