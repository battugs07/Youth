import 'package:youth/core/models/youth_council.dart';
import '../../locator.dart';
import 'api.dart';

class YouthCouncilService {
  Api api = locator<Api>();
  int _page = 1;

  int _aimagId = 1;
  int _soumId = 1;
  int _bkhId = 1;

  int get page => _page;
  int get aimagId => _aimagId;
  int get soumId => _soumId;
  int get bkhId => _bkhId;

  bool _hasData = false;
  bool get hasData => _hasData;

  List<YouthCouncil> _allYouthCounchils = [];
  List<YouthCouncil> _youthCounchils = [];

  List<YouthCouncil> get youthCouncilList => _youthCounchils;

  Future<void> getYouthCouncil(page, aimagId, soumId, bkhId, {bool isForced = false}) async {
    if (isForced) {
      _youthCounchils = [];
      _hasData = true;
    }

    _aimagId = aimagId;
    _soumId = soumId;
    _bkhId = bkhId;
    _page = page;

    _youthCounchils = await api.getYouthCouncil(page, aimagId, soumId, bkhId);
    _allYouthCounchils = await api.getYouthCouncil(page, aimagId, soumId, bkhId);

    if (_hasData) {
      if (page == 1 && _youthCounchils.length > 0) {
        return;
      }

      List<YouthCouncil> data = await api.getYouthCouncil(page, aimagId, soumId, bkhId);
      if (data.length == 0) {
        _hasData = false;
      } else {
        _youthCounchils = _youthCounchils + data;
      }
    } else {
      List<YouthCouncil> data = await api.getYouthCouncil(page, null, null, null);
      _youthCounchils = _youthCounchils + data;
    }
  }

  searchCouncil(String val) {
    _youthCounchils = _allYouthCounchils;
    if (val != '' || val != null) {
      _youthCounchils = _youthCounchils.where((c) => c.name!.toLowerCase().contains(val)).toList();
    }
  }
}
