import 'package:youth/core/models/national_council.dart';
import '../../locator.dart';
import 'api.dart';

class NationalCouncilService {
  Api api = locator<Api>();

  int _aimagId = 1;
  int _soumId = 1;

  int get aimagId => _aimagId;
  int get soumId => _soumId;

  bool _hasData = false;
  bool get hasData => _hasData;

  List<NationalCouncil> _allCouncils = [];
  List<NationalCouncil> _councils = [];

  List<NationalCouncil> get councilList => _councils;

  Future<void> getCouncils(aimagId, soumId, {bool isForced = false}) async {
    if (isForced) {
      _councils = [];
      _hasData = true;
    }

    _aimagId = aimagId;
    _soumId = soumId;

    _councils = await api.getNationalCouncil(aimagId, soumId);
    _allCouncils = await api.getNationalCouncil(aimagId, soumId);

    if (isForced) {
      List<NationalCouncil> data = await api.getNationalCouncil(aimagId, soumId);

      _councils = _councils + data;
    } else {
      List<NationalCouncil> data = await api.getNationalCouncil(null, null);
      _councils = _councils + data;
    }
  }

  searchCouncil(String val) {
    _councils = _allCouncils;
    if (val != '' || val != null) {
      _councils = _councils.where((t) => t.name!.toLowerCase().contains(val)).toList();
    }
  }
}
