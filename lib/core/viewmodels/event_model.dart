import 'package:youth/core/models/event.dart';
import 'package:youth/core/services/event_service.dart';
import 'package:youth/core/viewmodels/base_model.dart';

import '../../locator.dart';

class EventModel extends BaseModel {
  EventService _api = locator<EventService>();

  bool get hasData => _api.hasData;
  int get page => _api.page;

  List<Event> get eventList => _api.eventList;

  Future<void> getEventList(int aimagId, int page, {String? action}) async {
    switch (action) {
      case 'refresh':
        setLoading(true);
        await _api.getEventList(aimagId, page, isForced: true);
        notifyListeners();
        setLoading(false);
        break;
      case 'more':
        await _api.getEventList(aimagId, page);
        notifyListeners();
        break;
      default:
        setLoading(true);
        await _api.getEventList(aimagId, 1);
        setLoading(false);

        break;
    }
  }
}
