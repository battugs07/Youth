class KnowLedge {
  int? id;
  String? title;
  String? thumb;
  String? createdAt;
  String? description;
  String? content;
  int? views;

  KnowLedge({this.id, this.title, this.thumb, this.createdAt, this.description, this.content, this.views});

  KnowLedge.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    thumb = json['thumb'];
    createdAt = json['created_at'];
    description = json['description'];
    content = json['content'];
    views = json['views'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['thumb'] = this.thumb;
    data['created_at'] = this.createdAt;
    data['description'] = this.description;
    data['content'] = this.content;
    data['views'] = this.views;
    return data;
  }
}
