import 'package:youth/core/models/knowledge.dart';

import '../../locator.dart';
import 'api.dart';

class KnowLedgeService {
  Api api = locator<Api>();

  int _page = 1;
  int get page => _page;
  bool _hasData = true;
  bool get hasData => _hasData;

  List<KnowLedge> _knowLedge = [];
  List<KnowLedge> get knowLedgeList => _knowLedge;

  Future<void> getKnowLedgeServiceList(page, {bool isForced = false}) async {
    if (isForced) {
      _knowLedge = [];
      _hasData = true;
    }
    _page = page;

    if (_hasData) {
      if (page == 1 && _knowLedge.length > 0) {
        return;
      }
      List<KnowLedge> data = await api.getApiKnowLedge(page);
      if (data.length == 0) {
        _hasData = false;
      } else {
        _knowLedge = _knowLedge + data;
      }
    }
  }
}
