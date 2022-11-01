import 'package:youth/core/models/knowledge.dart';
import 'package:youth/core/services/knowledge_service.dart';
import 'package:youth/core/viewmodels/base_model.dart';

import '../../locator.dart';

class KnowLedgeModel extends BaseModel {
  KnowLedgeService _api = locator<KnowLedgeService>();

  bool get hasData => _api.hasData;
  int get page => _api.page;

  List<KnowLedge> get lawList => _api.knowLedgeList;

  Future<void> getLawModelList(int page, {String? action}) async {
    switch (action) {
      case 'refresh':
        setLoading(true);
        await _api.getKnowLedgeServiceList(page, isForced: true);
        notifyListeners();
        setLoading(false);
        break;
      case 'more':
        await _api.getKnowLedgeServiceList(page);
        notifyListeners();
        break;
      default:
        setLoading(true);
        await _api.getKnowLedgeServiceList(1);
        setLoading(false);

        break;
    }
  }
}
