import 'package:youth/core/models/event.dart';

import '../../locator.dart';
import 'api.dart';

class EventService {
  Api api = locator<Api>();

  int _page = 1;
  int get page => _page;
  bool _hasData = true;
  bool get hasData => _hasData;

  List<Event> _events = [];
  List<Event> get eventList => _events;

  Future<void> getEventList(aimagId, page, {bool isForced = false}) async {
    if (isForced) {
      _events = [];
      _hasData = true;
    }

    _page = page;

    if (_hasData) {
      if (page == 1 && _events.length > 0) {
        return;
      }
      List<Event> data = await api.getApiEvents(aimagId, page);
      if (data.length == 0) {
        _hasData = false;
      } else {
        _events = _events + data;
      }
    }
  }
}
