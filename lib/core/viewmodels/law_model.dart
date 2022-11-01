import 'package:youth/core/models/law.dart';
import 'package:youth/core/services/law_service.dart';
import 'package:youth/core/viewmodels/base_model.dart';

import '../../locator.dart';

class LawModel extends BaseModel {
  LawService _api = locator<LawService>();

  bool get hasData => _api.hasData;
  int get page => _api.page;

  List<Law> get lawList => _api.lawList;

  Future<void> getLawModelList(int page, {String? action}) async {
    switch (action) {
      case 'refresh':
        setLoading(true);
        await _api.getLawServiceList(page, isForced: true);
        notifyListeners();
        setLoading(false);
        break;
      case 'more':
        await _api.getLawServiceList(page);
        notifyListeners();
        break;
      default:
        setLoading(true);
        await _api.getLawServiceList(1);
        setLoading(false);

        break;
    }
  }
}
