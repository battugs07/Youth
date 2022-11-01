import 'package:youth/core/models/PodCast.dart';

import '../../locator.dart';
import 'api.dart';

class PodCastService {
  Api api = locator<Api>();

  int _page = 1;
  int get page => _page;
  bool _hasData = true;
  bool get hasData => _hasData;

  List<PodCast> _podCastList = [];
  List<PodCast> get podCastServiceList => _podCastList;

  Future<void> getPodCastServiceList(page, {bool isForced = false}) async {
    if (isForced) {
      _podCastList = [];
      _hasData = true;
    }
    _page = page;

    if (_hasData) {
      if (page == 1 && _podCastList.length > 0) {
        return;
      }
      List<PodCast> data = await api.getApiPodCast(page);
      if (data.length == 0) {
        _hasData = false;
      } else {
        _podCastList = _podCastList + data;
      }
    }
  }
}
