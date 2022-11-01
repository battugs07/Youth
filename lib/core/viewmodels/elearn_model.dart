import 'package:youth/core/models/Elearn.dart';
import 'package:youth/core/services/elearn_service.dart';
import 'package:youth/core/viewmodels/base_model.dart';

import '../../locator.dart';

class ElearnModel extends BaseModel {
  ElearnService _api = locator<ElearnService>();

  bool get hasData => _api.hasData;
  int get page => _api.page;

  List<Elearn> get elearnDataList => _api.eLearnList;

  Future<void> getElarnList(int page, {String? action}) async {
    switch (action) {
      case 'refresh':
        setLoading(true);
        await _api.getElearnServiceList(page, isForced: true);
        notifyListeners();
        setLoading(false);
        break;
      case 'more':
        await _api.getElearnServiceList(page);
        notifyListeners();
        break;
      default:
        setLoading(true);
        await _api.getElearnServiceList(1);
        setLoading(false);

        break;
    }
  }
}
