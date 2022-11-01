class Resolution {
  int? id;
  String? title;
  String? thumb;
  String? body;
  String? link;
  int? type;
  int? views;
  String? createdAt;
  String? file;
  int? zxzZuvlulId;

  Resolution({this.id, this.title, this.thumb, this.body, this.link, this.type, this.views, this.createdAt, this.file, this.zxzZuvlulId});

  Resolution.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    thumb = json['thumb'];
    body = json['body'];
    link = json['link'];
    type = json['type'];
    views = json['views'];
    createdAt = json['created_at'];
    file = json['file'];
    zxzZuvlulId = json['zxz_zuvlul_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['thumb'] = this.thumb;
    data['body'] = this.body;
    data['link'] = this.link;
    data['type'] = this.type;
    data['views'] = this.views;
    data['created_at'] = this.createdAt;
    data['file'] = this.file;
    data['zxz_zuvlul_id'] = this.zxzZuvlulId;
    return data;
  }
}
