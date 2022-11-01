import 'package:youth/core/models/youth_council.dart';
import 'package:youth/core/viewmodels/base_model.dart';
import 'package:youth/core/services/youth_council_service.dart';

import '../../locator.dart';

class YouthCouncilModel extends BaseModel {
  YouthCouncilService api = locator<YouthCouncilService>();

  bool get hasData => api.hasData;
  int get aimagId => api.aimagId;
  int get soumId => api.soumId;
  int get page => api.page;

  List<YouthCouncil> get youthCouncilList => api.youthCouncilList;

  Future<void> getYouthList(int page, int aimagId, int soumId, int bkhId, {String? action}) async {
    switch (action) {
      case 'selected':
        setLoading(true);
        await api.getYouthCouncil(page, aimagId, soumId, bkhId);
        notifyListeners();
        setLoading(false);
        break;

      case 'refresh':
        setLoading(true);
        await api.getYouthCouncil(1, aimagId, soumId, bkhId, isForced: true);
        notifyListeners();
        setLoading(false);
        break;
      case 'more':
        await api.getYouthCouncil(page, aimagId, soumId, bkhId);
        notifyListeners();
        break;

      default:
        setLoading(true);
        await api.getYouthCouncil(page, aimagId, soumId, bkhId);

        setLoading(false);
        break;
    }
    notifyListeners();
  }

  searchCouncil(val) {
    api.searchCouncil(val);
    notifyListeners();
  }
}
