class Law {
  int? id;
  String? title;
  String? thumb;
  String? body;
  String? link;
  int? views;
  String? createdAt;
  String? type;

  Law({this.id, this.title, this.thumb, this.body, this.link, this.views, this.createdAt, this.type});

  Law.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    thumb = json['thumb'];
    body = json['body'];
    link = json['link'];
    views = json['views'];
    createdAt = json['created_at'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['thumb'] = this.thumb;
    data['body'] = this.body;
    data['link'] = this.link;
    data['views'] = this.views;
    data['created_at'] = this.createdAt;
    data['type'] = this.type;
    return data;
  }
}
