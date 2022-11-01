class PodCast {
  int? id;
  String? channel;
  String? title;
  String? description;
  String? guest;
  String? img;
  String? embed;
  String? link;
  int? status;
  int? views;
  String? createdAt;

  PodCast(
      {this.id, this.channel, this.title, this.description, this.guest, this.img, this.embed, this.link, this.status, this.views, this.createdAt});

  PodCast.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    channel = json['channel'];
    title = json['title'];
    description = json['description'];
    guest = json['guest'];
    img = json['img'];
    embed = json['embed'];
    link = json['link'];
    status = json['status'];
    views = json['views'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['channel'] = this.channel;
    data['title'] = this.title;
    data['description'] = this.description;
    data['guest'] = this.guest;
    data['img'] = this.img;
    data['embed'] = this.embed;
    data['link'] = this.link;
    data['status'] = this.status;
    data['views'] = this.views;
    data['created_at'] = this.createdAt;
    return data;
  }
}
