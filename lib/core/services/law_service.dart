import 'package:youth/core/models/law.dart';

import '../../locator.dart';
import 'api.dart';

class LawService {
  Api api = locator<Api>();

  int _page = 1;
  int get page => _page;
  bool _hasData = true;
  bool get hasData => _hasData;

  List<Law> _laws = [];
  List<Law> get lawList => _laws;

  Future<void> getLawServiceList(page, {bool isForced = false}) async {
    if (isForced) {
      _laws = [];
      _hasData = true;
    }
    _page = page;

    if (_hasData) {
      if (page == 1 && _laws.length > 0) {
        return;
      }
      List<Law> data = await api.getApiLaws(page);
      if (data.length == 0) {
        _hasData = false;
      } else {
        _laws = _laws + data;
      }
    }
  }
}
