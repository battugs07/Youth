class AimagNews {
  int? id;
  String? title;
  String? description;
  String? thumb;
  String? createdAt;
  int? views;
  String? content;

  AimagNews({this.id, this.title, this.description, this.thumb, this.createdAt, this.views, this.content});

  AimagNews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    thumb = json['thumb'];
    createdAt = json['created_at'];
    views = json['views'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['thumb'] = this.thumb;
    data['created_at'] = this.createdAt;
    data['views'] = this.views;
    data['content'] = this.content;
    return data;
  }
}
