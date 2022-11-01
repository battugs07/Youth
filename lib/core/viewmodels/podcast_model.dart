import 'package:youth/core/models/PodCast.dart';
import 'package:youth/core/services/podcast_service.dart';
import 'package:youth/core/viewmodels/base_model.dart';

import '../../locator.dart';

class PodCastModel extends BaseModel {
  PodCastService _api = locator<PodCastService>();

  bool get hasData => _api.hasData;
  int get page => _api.page;

  List<PodCast> get podCastModelList => _api.podCastServiceList;

  Future<void> getPodCastList(int page, {String? action}) async {
    switch (action) {
      case 'refresh':
        setLoading(true);
        await _api.getPodCastServiceList(page, isForced: true);
        notifyListeners();
        setLoading(false);
        break;
      case 'more':
        await _api.getPodCastServiceList(page);
        notifyListeners();
        break;
      default:
        setLoading(true);
        await _api.getPodCastServiceList(1);
        setLoading(false);

        break;
    }
  }
}
