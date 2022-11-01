import 'package:youth/core/models/aimag_news.dart';
import '../../locator.dart';
import 'api.dart';

class AimagNewsService {
  Api api = locator<Api>();

  int _page = 1;
  int get page => _page;

  bool _hasData = true;
  bool get hasData => _hasData;

  List<AimagNews> _aimagNews = [];
  List<AimagNews> get aimagNewsList => _aimagNews;

  Future<void> getAimagNewsList(aimagId, page, {bool isForced = false}) async {
    if (isForced) {
      _aimagNews = [];
      _hasData = true;
    }
    _page = page;

    if (_hasData) {
      if (page == 1 && _aimagNews.length > 0) {
        print('hooson');
        return;
      }
      List<AimagNews> data = await api.getAimagNews(aimagId, page);
      if (data.length == 0) {
        _hasData = false;
      } else {
        _aimagNews = _aimagNews + data;
      }
    }
  }
}
