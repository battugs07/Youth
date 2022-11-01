import 'package:youth/core/models/Elearn.dart';

import '../../locator.dart';
import 'api.dart';

class ElearnService {
  Api api = locator<Api>();

  int _page = 1;
  int get page => _page;
  bool _hasData = true;
  bool get hasData => _hasData;

  List<Elearn> _eLearnList = [];
  List<Elearn> get eLearnList => _eLearnList;

  Future<void> getElearnServiceList(page, {bool isForced = false}) async {
    if (isForced) {
      _eLearnList = [];
      _hasData = true;
    }
    _page = page;

    if (_hasData) {
      if (page == 1 && _eLearnList.length > 0) {
        return;
      }
      List<Elearn> data = await api.getApiElearn(page);
      if (data.length == 0) {
        _hasData = false;
      } else {
        _eLearnList = _eLearnList + data;
      }
    }
  }
}
