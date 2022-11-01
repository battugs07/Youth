import 'package:youth/core/models/volunteer_work.dart';
import 'package:youth/core/services/volunteer_work_service.dart';
import 'package:youth/core/viewmodels/base_model.dart';

import '../../locator.dart';

class VolunteerWorkModel extends BaseModel {
  VolunteerWorkService _api = locator<VolunteerWorkService>();

  bool get hasData => _api.hasData;
  int get page => _api.page;

  List<VolunteerWork> get volunteerWorkList => _api.volunteerWorkList;

  Future<void> getVolunteerModelWorkList(int aimagId, int page, {String? action}) async {
    switch (action) {
      case 'refresh':
        setLoading(true);
        await _api.getVolunteerServiceWorkList(aimagId, page, isForced: true);
        notifyListeners();
        setLoading(false);
        break;
      case 'more':
        await _api.getVolunteerServiceWorkList(aimagId, page);
        notifyListeners();
        break;
      default:
        setLoading(true);
        await _api.getVolunteerServiceWorkList(aimagId, 1);
        setLoading(false);

        break;
    }
  }
}
