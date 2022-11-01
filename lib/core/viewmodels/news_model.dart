import 'package:youth/core/models/news.dart';
import 'package:youth/core/services/api.dart';
import 'package:meta/meta.dart';

import 'base_model.dart';

class NewsModel extends BaseModel {
  Api _api;

  NewsModel({
    required Api? api,
  }) : _api = api!;

  List<News> newsList = [];
  News? specialNews;

  Future getNewsList([bool force = false]) async {
    if (newsList.length == 0 || force) {
      setLoading(true);
//      newsList = await _api.getNewsList();
      setLoading(false);
    }
  }

  Future getSpecialNews([bool force = false]) async {
    if (specialNews == null || force) {
      setLoading(true);
//      specialNews = await _api.getSpecialNews();
      setLoading(false);
    }
  }
}
