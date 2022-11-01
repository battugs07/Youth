class News {
  int? _id;
  String? _title;
  String? _perex;
  String? _published_at;

  News.fromJson(Map<String, dynamic> parsedJson) {
    _id = parsedJson['id'];
    _title = parsedJson['title'];
    _perex = parsedJson['perex'];
    _published_at = parsedJson['published_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = _id;
    data['title'] = _title;
    data['body'] = _perex;
    data['published_at'] = _published_at;
    return data;
  }

  int? get id => _id;

  String? get title => _title;

  String? get perex => _perex;

  String? get published_at => _published_at;
}
