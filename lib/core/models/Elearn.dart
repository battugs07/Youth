class Elearn {
  int? id;
  String? title;
  String? headline;
  String? teachername;
  String? files;
  String? thumb;
  String? body;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? views;
  int? type;

  Elearn(
      {this.id,
      this.title,
      this.headline,
      this.teachername,
      this.files,
      this.thumb,
      this.body,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.views,
      this.type});

  Elearn.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    headline = json['headline'];
    teachername = json['teachername'];
    files = json['files'];
    thumb = json['thumb'];
    body = json['body'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    views = json['views'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['headline'] = this.headline;
    data['teachername'] = this.teachername;
    data['files'] = this.files;
    data['thumb'] = this.thumb;
    data['body'] = this.body;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['views'] = this.views;
    data['type'] = this.type;
    return data;
  }
}
