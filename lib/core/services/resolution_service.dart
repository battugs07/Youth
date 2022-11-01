import 'package:youth/core/models/resolution.dart';
import 'package:youth/locator.dart';

import 'api.dart';

class ResolutionService {
  Api api = locator<Api>();

  int _page = 1;
  int get page => _page;
  bool _hasData = true;
  bool get hasData => _hasData;

  List<Resolution> _resolutions = [];
  List<Resolution> get resolutionList => _resolutions;

  Future<void> getResolution(aimagId, type, page, {bool isForced = false}) async {
    if (isForced) {
      _resolutions = [];
      _hasData = true;
    }

    _page = page;

    if (_hasData) {
      if (page == 1 && _resolutions.length > 0) {
        return;
      }
      List<Resolution> data = await api.getData(aimagId, type, page);
      if (data.length == 0) {
        _hasData = false;
      } else {
        _resolutions = _resolutions + data;
      }
    }
  }
}
