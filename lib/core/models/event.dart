class Event {
  int? id;
  String? title;
  int? isPublish;
  String? address;
  String? location;
  String? eventDate1;
  String? eventDate2;
  String? banner;
  String? content;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? userId;
  int? personcount;
  int? aimagId;
  int? soumId;
  int? zxzZuvlulId;

  Event(
      {this.id,
      this.title,
      this.isPublish,
      this.address,
      this.location,
      this.eventDate1,
      this.eventDate2,
      this.banner,
      this.content,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.userId,
      this.personcount,
      this.aimagId,
      this.soumId,
      this.zxzZuvlulId});

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    isPublish = json['is_publish'];
    address = json['address'];
    location = json['location'];
    eventDate1 = json['event_date1'];
    eventDate2 = json['event_date2'];
    banner = json['banner'];
    content = json['content'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    userId = json['user_id'];
    personcount = json['personcount'];
    aimagId = json['aimag_id'];
    soumId = json['soum_id'];
    zxzZuvlulId = json['zxz_zuvlul_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['is_publish'] = this.isPublish;
    data['address'] = this.address;
    data['location'] = this.location;
    data['event_date1'] = this.eventDate1;
    data['event_date2'] = this.eventDate2;
    data['banner'] = this.banner;
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['user_id'] = this.userId;
    data['personcount'] = this.personcount;
    data['aimag_id'] = this.aimagId;
    data['soum_id'] = this.soumId;
    data['zxz_zuvlul_id'] = this.zxzZuvlulId;
    return data;
  }
}
